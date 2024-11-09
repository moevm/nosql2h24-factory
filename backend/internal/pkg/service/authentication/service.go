package authentication

import (
	"context"
	"time"
	domain "vvnbd/internal/pkg/domain/authentication"
)

type dao interface {
	GetUserAccessInfo(ctx context.Context, username string) (domain.UserAccessInfo, error)
	SetRefreshToken(ctx context.Context, secrets domain.RefreshTokenData) error
}

type Service struct {
	dao                  dao
	accessTokenLifetime  time.Duration
	refreshTokenLifetime time.Duration
	secretKey            []byte
}

func New(
	ctx context.Context,
	dao dao,
	accessTokenLifetime time.Duration,
	refreshTokenLifetime time.Duration,
	secretKey string) *Service {
	return &Service{
		dao:                  dao,
		accessTokenLifetime:  accessTokenLifetime,
		refreshTokenLifetime: refreshTokenLifetime,
		secretKey:            []byte(secretKey),
	}
}
