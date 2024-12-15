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

	type Avg struct {
		Sum   float64
		Count int
	}

	result := make(map[string]Avg)

	for _, record := range records {
		equipment := record.ValueByKey("equipment").(string)
		if request.Equipment != "" && request.Equipment != equipment {
			continue
		}

		field := record.Field()
		value := record.Value().(float64)
		avg := result[field]
		avg.Count += 1
		avg.Sum += value
		result[field] = avg
	}

	resp := make(map[string]float64)

	for field, val := range result {
		resp[field] = math.Round(val.Sum/float64(val.Count)*100) / 100
	}

	return c.JSON(http.StatusOK, resp)
}
