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

	result := struct {
		Daily  map[string]AverageData
		Weekly map[string]AverageData
		Hourly map[string]AverageData
	}{}

	result.Daily = map[string]AverageData{}
	result.Weekly = map[string]AverageData{}
	result.Hourly = map[string]AverageData{}

	for _, record := range records {
		timestamp := record.Time()
		value := record.Value().(float64)
		equipment := record.ValueByKey("equipment").(string)
		if request.Equipment != "" && request.Equipment != equipment {
			continue
		}

		// Daily average
		dateKey := timestamp.Format("2006-01-02")
		daily := result.Daily[dateKey]
		daily.Sum += value
		daily.Count++
		result.Daily[dateKey] = daily

		// Weekly average
		weekKey := strconv.Itoa(int(timestamp.Weekday()))
		weekly := result.Weekly[weekKey]
		weekly.Sum += value
		weekly.Count++
		result.Weekly[weekKey] = weekly

		// Hourly average
		hourKey := strconv.Itoa(timestamp.Hour())
		hourly := result.Hourly[hourKey]
		hourly.Sum += value
		hourly.Count++
		result.Hourly[hourKey] = hourly
	}

	// Prepare final result with only averages
	finalResult := make([]float64, 0)

	startTime, err := time.Parse("2006-01-02T15:04:05Z07:00", request.StartTime)
	if err != nil {
		return c.String(http.StatusBadRequest, "cannot parse start time")
	}

	if request.GroupBy == "day" {
		endTime, err := time.Parse("2006-01-02T15:04:05Z07:00", request.EndTime)
		if err != nil {
			return c.String(http.StatusBadRequest, "cannot parse end time")
		}

		hours := endTime.Sub(startTime).Hours()
		finalResult = make([]float64, int(math.Ceil(hours/24))+1)
	}

	if request.GroupBy == "weekday" {
		finalResult = make([]float64, 7)
	}

	if request.GroupBy == "hour" {
		finalResult = make([]float64, 24)
	}

	if request.GroupBy == "day" {

		for date, val := range result.Daily {
			time, err := time.Parse("2006-01-02", date)
			if err != nil {
				return c.String(http.StatusBadRequest, "cannot parse day time")
			}

			day := int(math.Ceil(time.Sub(startTime).Hours() / 24))
			finalResult[day] = val.Sum / float64(val.Count)
		}
	}

	if request.GroupBy == "weekday" {
		for week, val := range result.Weekly {
			idx, err := strconv.Atoi(week)
			if err != nil {
				return c.String(http.StatusBadRequest, "cannot parse week")
			}

			finalResult[idx] = val.Sum / float64(val.Count)
		}
	}

	if request.GroupBy == "hour" {
		for week, val := range result.Hourly {
			idx, err := strconv.Atoi(week)
			if err != nil {
				return c.String(http.StatusBadRequest, "cannot parse hour")
			}

			finalResult[idx] = val.Sum / float64(val.Count)
		}
	}

	return c.JSON(http.StatusOK, finalResult)
}
