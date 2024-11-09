package testinfluxrepo

import (
	"fmt"
	"vvnbd/internal/pkg/domain/db"

	"golang.org/x/net/context"
)

var (
	getQuery = fmt.Sprintf(`from(bucket:"%s")|> range(start: -1h) |> filter(fn: (r) => r._measurement == "stat")`, bucket)
)

func (r *Repository) GetPoint(ctx context.Context) (string, error) {
	queryAPI := r.client.QueryAPI(org)

	result, err := queryAPI.Query(context.Background(), getQuery)
	if err != nil {
		return "", fmt.Errorf("unable to execute get point query Err: %w", err)
	}

	if result.Err() != nil {
		return "", fmt.Errorf("cannot get point due query error Err: %w", err)
	}

	if result.Next() {
		return fmt.Sprintf("row: %s\n", result.Record().String()), nil
	}

	return "", &db.NotFoundError{}
}
