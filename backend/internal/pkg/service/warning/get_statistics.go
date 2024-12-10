package warning

import (
	"context"
	"database/sql"
	"fmt"
	"strconv"
	"time"
	domain "vvnbd/internal/pkg/domain/warning"
)

func (s *Service) GetStatistics(ctx context.Context, request domain.GetStatisticsRequest) ([]domain.GetStatisticsResponse, error) {
	start, _ := time.Parse("2006-01-02T15:04:05Z07:00", request.StartDate)
	end, _ := time.Parse("2006-01-02T15:04:05Z07:00", request.EndDate)

	filter := domain.GetStatisticsFilter{
		StartDate:     start,
		EndDate:       end,
		GroupBy:       request.GroupBy,
		Metric:        request.Metric,
		ExcessPercent: request.ExcessPercent,
	}

	if request.Equipment != "" {
		filter.Equipment = sql.NullString{
			String: request.Equipment,
			Valid:  true,
		}
	}

	stats, err := s.dao.GetStatistics(ctx, filter)
	if err != nil {
		return nil, fmt.Errorf("unable to get statistics info. Err: %w", err)
	}

	statsMap := make(map[string]float64, len(stats))
	for _, stat := range stats {
		statsMap[stat.StatNumber] = stat.Value
	}

	dayHelper := make(map[int]string)

	weekdays := []string{"Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"}

	resp := []domain.GetStatisticsResponse{}
	respLen := 0
	if request.GroupBy == "day" {
		currentDate := start
		for currentDate.Before(end) {
			dayHelper[respLen] = currentDate.Format("2006-01-02")
			respLen++
			currentDate = currentDate.Add(24 * time.Hour)
		}
	}
	if request.GroupBy == "weekday" {
		respLen = 7
	}
	if request.GroupBy == "hour" {
		respLen = 24
	}

	for i := 0; i < respLen; i++ {
		idx := i
		strIdx := ""

		if request.GroupBy == "day" {
			strIdx = dayHelper[idx]
		} else {
			strIdx = strconv.Itoa(idx)
		}

		val, ok := statsMap[strIdx]
		if !ok {
			resp = append(resp, domain.GetStatisticsResponse{})
			continue
		}

		display_val := strIdx
		if request.GroupBy == "weekday" {
			display_val = weekdays[idx]
		}

		resp = append(resp, domain.GetStatisticsResponse{
			Values: display_val,
			Points: val,
		})
	}

	return resp, nil
}
