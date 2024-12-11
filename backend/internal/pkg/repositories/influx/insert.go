package influx_repo

import (
	"context"
	"fmt"
)

func (r *Repository) Insert(ctx context.Context, records *string) error {
	insertAPI := r.client.WriteAPIBlocking(r.orgName, r.bucketName)

	err := insertAPI.WriteRecord(ctx, *records)
	if err != nil {
		return fmt.Errorf("unable to insert records Err: %w", err)
	}

	return nil
}
