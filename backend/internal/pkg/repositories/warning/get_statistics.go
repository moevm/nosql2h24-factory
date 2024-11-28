package warning

import (
	"context"
	"fmt"
	"vvnbd/internal/pkg/domain/warning"

	"go.mongodb.org/mongo-driver/bson"
)

var (
	groupByExpr = bson.M{
		"day": bson.M{
			"$dateToString": bson.M{
				"format": "%Y-%m-%d",
				"date":   "$date",
			},
		},
		"weekday": bson.M{
			"$dateToString": bson.M{
				"format": "%w",
				"date":   "$date",
			},
		},
		"hour": bson.M{
			"$dateToString": bson.M{
				"format": "%H",
				"date":   "$date",
			},
		},
	}

	metricExpr = bson.M{
		"count": bson.M{
			"$sum": 1,
		},
		"avg_excess": bson.M{
			"$avg": "$excess_percent",
		},
		"avg_duration": bson.M{
			"$avg": bson.M{
				"$divide": bson.A{
					bson.M{
						"$subtruct": bson.A{"$date_to", "$date_from"},
					},
					1000,
				},
			},
		},
	}
)

func (r *Repository) GetStatistics(ctx context.Context, filter warning.GetStatisticsFilter) ([]warning.Statistics, error) {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	queryFilter := applyStatisticsFilter(filter)

	cur, err := coll.Aggregate(ctx, queryFilter)
	if err != nil {
		return nil, fmt.Errorf("unable to get data from mongo. Err: %w", err)
	}

	var result []warning.Statistics
	err = cur.All(ctx, &result)
	if err != nil {
		return nil, fmt.Errorf("unable to parse data from from mongo. Err: %w", err)
	}

	return result, nil
}

func applyStatisticsFilter(filter warning.GetStatisticsFilter) bson.A {

	matchStageExpr := bson.M{
		"date":           bson.M{"$gte": filter.StartDate, "$lte": filter.EndDate},
		"excess_percent": bson.M{"$gte": filter.ExcessPercent},
	}

	if filter.Equipment.Valid {
		matchStageExpr["equipment"] = filter.Equipment.String
	}

	matchStage := bson.M{"$match": matchStageExpr}

	groupStage := bson.M{
		"$group": bson.M{
			"_id":   groupByExpr[filter.GroupBy],
			"value": metricExpr[filter.Metric],
		},
	}

	sortStage := bson.M{"$sort": bson.M{"_id": 1}}

	return bson.A{matchStage, groupStage, sortStage}
}
