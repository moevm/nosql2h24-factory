package influx_parser

import (
	"fmt"
	"log"
	"net/http"
	"time"

	"github.com/labstack/echo"
)

type PointData struct {
	Time  time.Time   `json:"time"`
	Value interface{} `json:"value"`
}

type liveChartsRequest struct {
	StartTime            string                         `json:"start_time"`
	EndTime              string                         `json:"end_time"`
	Interval             string                         `json:"interval"`
	AggFunc              string                         `json:"aggregate_function"`
	EquipmentsParameters map[string]map[string][]string `json:"equipments_parameters"`
}

func (h *Handler) LiveCharts(c echo.Context) error {
	var request liveChartsRequest
	err := c.Bind(&request)
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusBadRequest)
	}

	result := make(map[string]map[string]map[string][]interface{})

	for equipKey, parameters := range request.EquipmentsParameters {
		equipment, err := h.equipmentRepo.GetEquipment(c.Request().Context(), equipKey)
		if err != nil {
			return c.String(http.StatusInternalServerError, fmt.Sprintf("Failed to get equipment data for %s", equipKey))
		}

		fmt.Println(equipment)

		result[equipKey] = make(map[string]map[string][]interface{})

		for param, subParams := range parameters {
			if paramData, ok := equipment.Parameters[param]; ok {
				result[equipKey][param] = make(map[string][]interface{})

				for _, subParam := range subParams {
					subParamData, ok := paramData.Subparameters[subParam]
					if !ok {
						log.Printf("Subparameter %s not found for equipment %s", subParam, equipKey)
						continue
					}
					topic := subParamData.Topic

					points, err := h.influxRepo.AnyQuery(
						c.Request().Context(),
						`|> range(start: %s, stop: %s)
                        |> filter(fn: (r) => r.topic == "%s")
                        |> filter(fn: (r) => r._field == "value")
                        |> aggregateWindow(every: %s, fn: %s, createEmpty: false)
                        `,
						request.StartTime,
						request.EndTime,
						topic,
						request.Interval,
						request.AggFunc,
					)
					if err != nil {
						return c.String(http.StatusInternalServerError, fmt.Sprintf("err while do query %s", err))
					}

					var resultPoints []interface{}
					for _, point := range points {
						resultPoints = append(resultPoints, PointData{
							Time:  point.Time(),
							Value: point.Value(),
						})
					}

					result[equipKey][param][subParam] = resultPoints
				}
			} else {
				log.Printf("Parameter %s not found for equipment %s", param, equipKey)
			}
		}
	}

	return c.JSON(http.StatusOK, result)
}
