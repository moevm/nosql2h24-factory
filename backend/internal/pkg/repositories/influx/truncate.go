package influx_repo

import (
	"context"
	"fmt"
	"time"
)

func (r *Repository) Truncate(ctx context.Context) error {
	deleteAPI := r.client.DeleteAPI()
	err := deleteAPI.DeleteWithName(ctx, r.orgName, r.bucketName, time.Now().Add(-24*365*30*time.Hour), time.Now(), "")
	if err != nil {
		return fmt.Errorf("unable to truncate records Err: %w", err)
	}

	return nil
}
