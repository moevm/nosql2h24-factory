package warning

import (
	"context"
	"fmt"
	domain "vvnbd/internal/pkg/domain/warning"
)

func (s *Service) SetViewed(ctx context.Context, viewedWarnings []domain.WarningsViewed) error {
	err := s.dao.SetViewed(ctx, viewedWarnings)
	if err != nil {
		return fmt.Errorf("unable to set viewd warnings. Err: %w", err)
	}

	return nil
}
