package testinfluxrepo

import (
	influxdb2 "github.com/influxdata/influxdb-client-go/v2"
	"golang.org/x/net/context"
)

type Repository struct {
	client influxdb2.Client
}

func NewRepository(ctx context.Context, client influxdb2.Client) *Repository {
	return &Repository{
		client: client,
	}
}
