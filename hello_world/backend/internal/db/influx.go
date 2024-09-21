package db

import (
	"context"

	influxdb2 "github.com/influxdata/influxdb-client-go/v2"
)

const (
	token = "test_token"
)

func NewInfluxClient(ctx context.Context) influxdb2.Client {
	return influxdb2.NewClient("http://influxdb2:8086", token)
}
