package db

import (
	"context"
	"fmt"
	"vvnbd/internal/config"

	influxdb2 "github.com/influxdata/influxdb-client-go/v2"
)

func NewInfluxClient(ctx context.Context) (influxdb2.Client, error) {
	token, err := config.GetValue(config.InfluxToken)
	if err != nil {
		return nil, fmt.Errorf("unable to get influx token: %w", err)
	}

	return influxdb2.NewClient("http://influxdb2:8086", token), nil
}
