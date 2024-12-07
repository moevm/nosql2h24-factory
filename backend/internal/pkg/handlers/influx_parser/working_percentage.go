package influx_parser

import (
	"fmt"
	"math"
	"net/http"

	"github.com/labstack/echo"
)

type workingPercentageRequest struct {
	Equipment string `json:"equipment"`
	StartTime string `json:"start_time"`
	EndTime   string `json:"end_time"`
}

func (h *Handler) WorkingPercentage(c echo.Context) error {
	var request workingPercentageRequest
	err := c.Bind(&request)
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusBadRequest)
	}

	records, err := h.influxRepo.AnyQuery(
		c.Request().Context(),
		`
            |> range(start: %s, stop: %s)
            |> filter(fn: (r) => r._measurement == "equipment_working_percentage")
            |> filter(fn: (r) => r._field == "turn_off" or r._field == "turn_on" or r._field == "work")
            |> group(columns: ["equipment", "_field"])
            |> mean()
        `,
		request.StartTime, request.EndTime,
	)
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Sprintf("err while do query %s", err))
	}

	result := make(map[string]map[string]float64)

	for _, record := range records {
		equipment := record.ValueByKey("equipment").(string)
		field := record.Field()
		value := record.Value().(float64)

		if _, ok := result[equipment]; !ok {
			result[equipment] = make(map[string]float64)
		}
		result[equipment][field] = math.Round(value*100) / 100 // Round to 2 decimal places
	}

	if request.Equipment != "" {
		return c.JSON(http.StatusOK, map[string]map[string]float64{
			request.Equipment: result[request.Equipment],
		})
	}

	return c.JSON(http.StatusOK, result)
}
