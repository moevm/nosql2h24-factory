package warning

import (
	"context"
	"database/sql"
	"fmt"
	domain "vvnbd/internal/pkg/domain/warning"
)

func (s *Service) GetStatistics(ctx context.Context, request domain.GetStatisticsRequest) ([]domain.GetStatisticsResponse, error) {
	filter := domain.GetStatisticsFilter{
		StartDate:     request.StartDate,
		EndDate:       request.EndDate,
		GroupBy:       request.GroupBy,
		Metric:        request.Metric,
		ExcessPercent: request.ExcessPercent,
	}

	if request.Equipment != nil {
		filter.Equipment = sql.NullString{
			String: *request.Equipment,
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
