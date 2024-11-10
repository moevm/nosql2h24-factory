package authentication

import (
	"context"
	"time"
	domain "vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/domain/staff"
)

type usersDao interface {
	GetUserAccessInfo(ctx context.Context, username string) (domain.UserAccessInfo, error)
	SetRefreshToken(ctx context.Context, secrets domain.RefreshTokenData) error
}

type staffDao interface {
	GetOne(ctx context.Context, username string) (staff.PersonData, error)
}

type Service struct {
	usersDao             usersDao
	staffDao             staffDao
	accessTokenLifetime  time.Duration
	refreshTokenLifetime time.Duration
	secretKey            []byte
}

func New(
	ctx context.Context,
	usersDao usersDao,
	staffDao staffDao,
	accessTokenLifetime time.Duration,
	refreshTokenLifetime time.Duration,
	secretKey string) *Service {
	return &Service{
		usersDao:             usersDao,
		staffDao:             staffDao,
		accessTokenLifetime:  accessTokenLifetime,
		refreshTokenLifetime: refreshTokenLifetime,
		secretKey:            []byte(secretKey),
	}
}
