package warning

import (
	"context"
	"vvnbd/internal/pkg/domain/warning"
)

type dao interface {
	GetWarnings(ctx context.Context, filter warning.GetWarningsFilter, options warning.GetWarningsOption) ([]warning.Warning, error)
	GetWarningsCount(ctx context.Context, filter warning.GetWarningsFilter) (int64, error)
	SetViewed(ctx context.Context, viewedWarnings []warning.WarningsViewed) error
	SetDescription(ctx context.Context, id string, description *warning.Description) error
}

type Service struct {
	dao dao
}

func New(
	ctx context.Context,
	dao dao) *Service {
	return &Service{
		dao: dao,
	}
}
