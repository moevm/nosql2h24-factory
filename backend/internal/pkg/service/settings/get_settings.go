package settings

import (
	"context"
	"fmt"
)

func (s *Service) GetSettings(ctx context.Context, username string) (string, error) {
	user, err := s.staffDao.GetOne(ctx, username)
	if err != nil {
		return "", fmt.Errorf("unable to get user info. Err: %w", err)
	}

	return user.Settings, nil
}
