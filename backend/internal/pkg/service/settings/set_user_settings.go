package settings

import (
	"context"
	"fmt"
)

func (s *Service) SetUserSettings(ctx context.Context, username string, settings string) error {
	err := s.staffDao.SetSettings(ctx, username, settings)
	if err != nil {
		return fmt.Errorf("[settings] unable to set user settings. Err: %w", err)
	}

	return nil
}
