package influx_repo

import (
	"context"
	"fmt"
	"strings"
	"time"
)

func (r *Repository) GetAllRecords(ctx context.Context) (string, error) {
	queryAPI := r.client.QueryAPI(r.orgName)

	query := fmt.Sprintf(
		`from(bucket:"%s")
		|> range(start: %s, stop: %s)`,
		r.bucketName, time.Time{}.Format("2006-01-02"), time.Now().Format("2006-01-02"),
	)

	results, err := queryAPI.Query(ctx, query)
	if err != nil {
		return "", fmt.Errorf("failed to query for %s: Err: %w", query, err)
	}

	builder := strings.Builder{}
	for results.Next() {
		record := results.Record()
		builder.WriteString(record.String() + "\n")
	}

	if results.Err() != nil {
		return "", fmt.Errorf("error parsing query result for %s: %v", query, results.Err())
	}

	return builder.String(), nil
}
