package influx_parser

import (
	"fmt"
	"math"
	"net/http"
	"strconv"
	"time"

	"github.com/labstack/echo"
)

type workPercentRequest struct {
	Equipment string `json:"equipment"`
	GroupBy   string `json:"group_by"`
	StartTime string `json:"start_time"`
	EndTime   string `json:"end_time"`
}

func (h *Handler) WorkPercent(c echo.Context) error {
	var request workPercentRequest
	err := c.Bind(&request)
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusBadRequest)
	}

	records, err := h.influxRepo.AnyQuery(
		c.Request().Context(),
		`
            |> range(start: %s, stop: %s)
            |> filter(fn: (r) => r._measurement == "equipment_working_percentage" and r._field == "work")
            |> aggregateWindow(every: 1h, fn: mean)
    	`, request.StartTime, request.EndTime,
	)
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Sprintf("err while do query %s", err))
	}

	type AverageData struct {
		Sum   float64
		Count int
	}

	result := make(map[string]struct {
		Daily  map[string]AverageData
		Weekly map[string]AverageData
		Hourly map[string]AverageData
	})

	for _, record := range records {
		timestamp := record.Time()
		value := record.Value().(float64)
		equipment := record.ValueByKey("equipment").(string)

		if _, ok := result[equipment]; !ok {
			result[equipment] = struct {
				Daily  map[string]AverageData
				Weekly map[string]AverageData
				Hourly map[string]AverageData
			}{
				Daily:  make(map[string]AverageData),
				Weekly: make(map[string]AverageData),
				Hourly: make(map[string]AverageData),
			}
		}

		// Daily average
		dateKey := timestamp.Format("2006-01-02")
		daily := result[equipment].Daily[dateKey]
		daily.Sum += value
		daily.Count++
		result[equipment].Daily[dateKey] = daily

		// Weekly average
		weekKey := strconv.Itoa(int(timestamp.Weekday()))
		weekly := result[equipment].Weekly[weekKey]
		weekly.Sum += value
		weekly.Count++
		result[equipment].Weekly[weekKey] = weekly

		// Hourly average
		hourKey := strconv.Itoa(timestamp.Hour())
		hourly := result[equipment].Hourly[hourKey]
		hourly.Sum += value
		hourly.Count++
		result[equipment].Hourly[hourKey] = hourly
	}

	// Prepare final result with only averages
	finalResult := make(map[string][]float64)

	if request.Equipment != "" {
		finalResult[request.Equipment] = make([]float64, 0)
	}

	for equipment, data := range result {
		if request.Equipment != "" && request.Equipment != equipment {
			continue
		}

		if request.GroupBy == "day" {
			startTime, err := time.Parse("2006-01-02T15:04:05+07:00", request.StartTime)
			if err != nil {
				return c.String(http.StatusBadRequest, "cannot parse time")
			}

			endTime, err := time.Parse("2006-01-02", request.EndTime)
			if err != nil {
				return c.String(http.StatusBadRequest, "cannot parse time")
			}

			hours := endTime.Sub(startTime).Hours()
			finalResult[equipment] = make([]float64, int(math.Ceil(hours/24))+1)

			for date, val := range data.Daily {
				time, err := time.Parse("2006-01-02", date)
				if err != nil {
					return c.String(http.StatusBadRequest, "cannot parse time")
				}

				day := int(math.Ceil(time.Sub(startTime).Hours() / 24))
				finalResult[equipment][day] = val.Sum / float64(val.Count)
			}
		}

		if request.GroupBy == "weekday" {
			finalResult[equipment] = make([]float64, 7)

			for week, val := range data.Weekly {
				idx, err := strconv.Atoi(week)
				if err != nil {
					return c.String(http.StatusBadRequest, "cannot parse week")
				}

				finalResult[equipment][idx] = val.Sum / float64(val.Count)
			}
		}

		if request.GroupBy == "hour" {
			finalResult[equipment] = make([]float64, 24)

			for week, val := range data.Hourly {
				idx, err := strconv.Atoi(week)
				if err != nil {
					return c.String(http.StatusBadRequest, "cannot parse hour")
				}

				finalResult[equipment][idx] = val.Sum / float64(val.Count)
			}
		}
	}

	return c.JSON(http.StatusOK, finalResult)
}
