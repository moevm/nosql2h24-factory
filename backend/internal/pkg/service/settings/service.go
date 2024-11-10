package settings

import (
	"context"
	"vvnbd/internal/pkg/domain/staff"
)

type staffDao interface {
	GetOne(ctx context.Context, username string) (staff.PersonData, error)
	SetSettings(ctx context.Context, username string, settings string) error
}

type Service struct {
	staffDao staffDao
}

func New(
	ctx context.Context,
	staffDao staffDao) *Service {
	return &Service{
		staffDao: staffDao,
	}
}
