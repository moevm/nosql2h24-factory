package warning

import (
	"context"
	"fmt"
	domain "vvnbd/internal/pkg/domain/warning"
)

func (s *Service) GetEquipmentStatistics(ctx context.Context, request domain.GetEquipmentStatisticsRequest) (domain.GetEquipmentStatisticsResponse, error) {
	stats, err := s.dao.GetEquipmentStatistics(ctx, request)
	if err != nil {
		return domain.GetEquipmentStatisticsResponse{}, fmt.Errorf("[warnings] unable to get statistics info. Err: %w", err)
	}

	return stats, nil
}
