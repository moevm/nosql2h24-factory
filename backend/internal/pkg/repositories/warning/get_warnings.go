package warning

import (
	"context"
	"fmt"
	"vvnbd/internal/pkg/domain/warning"

	"go.mongodb.org/mongo-driver/bson"
	opts "go.mongodb.org/mongo-driver/mongo/options"
)

func (r *Repository) GetWarnings(ctx context.Context, filter warning.GetWarningsFilter, options warning.GetWarningsOption) ([]warning.Warning, error) {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	queryFilter := applyFilter(bson.M{}, filter)

	queryOptions := opts.Find()
	applyOptions(queryOptions, options)

	cur, err := coll.Find(ctx, queryFilter, queryOptions)
	if err != nil {
		return nil, fmt.Errorf("unable to get data from mongo. Err: %w", err)
	}

	var result []warning.Warning
	err = cur.All(ctx, &result)
	if err != nil {
		return nil, fmt.Errorf("unable to parse data from from mongo. Err: %w", err)
	}

	return result, nil
}

func applyFilter(query bson.M, filter warning.GetWarningsFilter) bson.M {

	if filter.Equipment.Valid {
		query[equipmentField] = filter.Equipment.String
	}

	if filter.ExcessPercentGreatetThan.Valid {
		query[excessPercentField] = bson.M{"$gte": filter.ExcessPercentGreatetThan.Float64}
	}

	if filter.EalrierThan.Valid {
		query[dateFromField] = bson.M{"$lte": filter.EalrierThan.Time}
	}

	if filter.LaterThan.Valid {
		if dateQuery, ok := query[dateFromField]; ok {
			dateQuery.(bson.M)["$gte"] = filter.LaterThan.Time
		} else {
			query[dateFromField] = bson.M{"$gte": filter.LaterThan.Time}
		}
	}

	if filter.IsWithDescription.Valid {
		descFilter := bson.M{"$exists": filter.IsWithDescription.Bool}
		if filter.IsWithDescription.Bool {
			descFilter["$ne"] = nil
		}
		query[descriptionField] = descFilter
	}

	if filter.IsViewed.Valid {
		var viewedQuery interface{} = filter.IsViewed.Bool
		if !filter.IsViewed.Bool {
			viewedQuery = bson.M{"$ne": true}
		}
		query[viewedField] = viewedQuery
	}

	return query
}

func applyOptions(options *opts.FindOptions, getOptions warning.GetWarningsOption) {
	if getOptions.DateFromOrderAsc.Valid {
		order := 1
		if getOptions.DateFromOrderAsc.Bool {
			order = -1
		}
		options.SetSort(bson.M{dateFromField: order})
	}

	if getOptions.Limit.Valid {
		options.SetLimit(getOptions.Limit.Int64)
	}

	if getOptions.Offset.Valid {
		options.SetSkip(getOptions.Offset.Int64)
	}
}
