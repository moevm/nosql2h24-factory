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
		builder.WriteString(record.Measurement())
		for key, val := range record.Values() {
			if key[0] == '_' || key == "result" || key == "table" {
				continue
			}
			builder.WriteString(",")
			builder.WriteString(key)
			builder.WriteString("=")
			builder.WriteString(strings.ReplaceAll(fmt.Sprint(val), " ", "\\ "))
		}
		builder.WriteString(" ")
		builder.WriteString(record.Field())
		builder.WriteString("=")
		builder.WriteString(fmt.Sprint(record.Value()))
		builder.WriteString(" ")
		builder.WriteString(fmt.Sprint(record.Time().UnixNano()))

		builder.WriteString("\n")
	}

	if results.Err() != nil {
		return "", fmt.Errorf("error parsing query result for %s: %v", query, results.Err())
	}

	return builder.String(), nil
}
