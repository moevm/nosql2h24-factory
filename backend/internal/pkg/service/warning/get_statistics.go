package warning

import (
	"context"
	"database/sql"
	"fmt"
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

	resp := []domain.GetStatisticsResponse{}
	for _, stat := range stats {
		resp = append(resp, domain.GetStatisticsResponse{
			Values: stat.StatNumber,
			Points: stat.Value,
		})
	}

	return resp, nil
}
