package testinfluxrepo

import (
	"context"
	"fmt"

	"github.com/influxdata/influxdb-client-go/v2/api/write"
)

const (
	org    = "docs"
	bucket = "test_bucket"
)

func (r *Repository) SetPoint(ctx context.Context, point *write.Point) error {
	api := r.client.WriteAPIBlocking(org, bucket)

	err := api.WritePoint(ctx, point)
	if err != nil {
		return fmt.Errorf("unable to insert point Err: %w", err)
	}

	return nil
}
