package warning

import (
	"context"
	"database/sql"
	"fmt"
	"slices"
	domain "vvnbd/internal/pkg/domain/warning"
)

func (s *Service) GetWarnings(ctx context.Context, request domain.GetWarningsRequest) (domain.GetWarningsResponse, error) {

	filter := domain.GetWarningsFilter{
		ExcessPercentGreatetThan: sql.NullFloat64{
			Float64: request.ExcessPercent,
			Valid:   request.ExcessPercent != 0,
		},
		Equipment: sql.NullString{
			String: request.Equipment,
			Valid:  request.Equipment != "",
		},
		LaterThan: sql.NullTime{
			Time:  request.StartDate,
			Valid: !request.StartDate.IsZero(),
		},
		EalrierThan: sql.NullTime{
			Time:  request.EndDate,
			Valid: !request.EndDate.IsZero(),
		},
		IsWithDescription: sql.NullBool{
			Bool:  request.IsWithDescription,
			Valid: true,
		},
		IsViewed: sql.NullBool{
			Bool:  request.Viewed,
			Valid: true,
		},
	}

	options := domain.GetWarningsOption{
		Limit: sql.NullInt64{
			Int64: int64(request.PageLen),
			Valid: request.PageLen != 0,
		},
		Offset: sql.NullInt64{
			Int64: int64(request.PageNum-1) * int64(request.PageLen),
			Valid: request.PageLen != 0 && request.PageNum != 0,
		},
		DateFromOrderAsc: sql.NullBool{
			Bool:  request.IsOrderASC,
			Valid: true,
		},
	}

	totalWarningsCount, err := s.dao.GetWarningsCount(ctx, filter)
	if err != nil {
		return domain.GetWarningsResponse{}, fmt.Errorf("unable to get warnings info. Err: %w", err)
	}

	if totalWarningsCount == 0 {
		return domain.GetWarningsResponse{
			PageNum: request.PageNum,
			PageLen: request.PageLen,
		}, nil
	}

	warnings, err := s.dao.GetWarnings(ctx, filter, options)
	if err != nil {
		return domain.GetWarningsResponse{}, fmt.Errorf("unable to get warnings info. Err: %w", err)
	}

	slices.SortFunc(warnings, func(a domain.Warning, b domain.Warning) int {
		if a.DateFrom.Equal(b.DateFrom) {
			return 0
		}

		if a.DateFrom.Before(b.DateFrom) {
			return 1
		}

		return -1
	})

	return domain.GetWarningsResponse{
		Warnings:           warnings,
		PageNum:            request.PageNum,
		PageLen:            request.PageLen,
		TotalWarningsCount: int(totalWarningsCount),
		PagesCount:         (int(totalWarningsCount) + request.PageLen - 1) / request.PageLen,
	}, nil
}
