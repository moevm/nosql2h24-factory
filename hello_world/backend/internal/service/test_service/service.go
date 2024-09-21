package testservice

import (
	"context"
	"vvnbd/internal/domain"

	"github.com/influxdata/influxdb-client-go/v2/api/write"
)

type influxRepo interface {
	GetPoint(ctx context.Context) (string, error)
	SetPoint(ctx context.Context, point *write.Point) error
}

type mongoRepo interface {
	GetHelloWorld(ctx context.Context, login string) (domain.HelloWorld, error)
	InsertHelloWorld(ctx context.Context, helloWorld domain.HelloWorld) error
}

type Service struct {
	mongoRepo  mongoRepo
	influxRepo influxRepo
}

func NewService(ctx context.Context, mongoRepo mongoRepo, ininfluxRepo influxRepo) *Service {
	return &Service{
		mongoRepo:  mongoRepo,
		influxRepo: ininfluxRepo,
	}
}
