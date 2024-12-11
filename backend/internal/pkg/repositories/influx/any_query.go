package influx_repo

import (
	"context"
	"fmt"

	influx "github.com/influxdata/influxdb-client-go/v2/api/query"
)

func (r *Repository) AnyQuery(ctx context.Context, query string, args ...interface{}) ([]*influx.FluxRecord, error) {
	queryAPI := r.client.QueryAPI(r.orgName)

	query = fmt.Sprintf(`from(bucket:"%s")`, r.bucketName) + fmt.Sprintf(query, args...)

	results, err := queryAPI.Query(ctx, query)
	if err != nil {
		return nil, fmt.Errorf("failed to query for %s: Err: %w", query, err)
	}

	var dataPoints []*influx.FluxRecord
	for results.Next() {
		record := results.Record()
		dataPoints = append(dataPoints, record)
	}

	if results.Err() != nil {
		return nil, fmt.Errorf("error parsing query result for %s: %v", query, results.Err())
	}

	return dataPoints, nil
}
