package warning

import (
	"context"
	"fmt"
	"time"
	domain "vvnbd/internal/pkg/domain/warning"
)

func (s *Service) SetDescription(ctx context.Context, username string, request domain.SetDescriptionsRequest) error {
	if request.Description != nil {
		request.Description.Author = username
		request.Description.UpdatedAt = time.Now()
	}

	err := s.dao.SetDescription(ctx, request.Id, request.Description)
	if err != nil {
		return fmt.Errorf("unable to set warning description. Err: %w", err)
	}

	return nil
}
