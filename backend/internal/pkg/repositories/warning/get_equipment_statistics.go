package warning

import (
	"context"
	"fmt"
	"time"
	"vvnbd/internal/pkg/domain/warning"

	"go.mongodb.org/mongo-driver/bson"
)

func (r *Repository) GetEquipmentStatistics(ctx context.Context, filter warning.GetEquipmentStatisticsRequest) (warning.GetEquipmentStatisticsResponse, error) {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	queryFilter := applyEquipmentStatisticsFilter(filter)

	cur, err := coll.Aggregate(ctx, queryFilter)
	if err != nil {
		return warning.GetEquipmentStatisticsResponse{}, fmt.Errorf("unable to get data from mongo. Err: %w", err)
	}

	var result []warning.EquipmentStatistics
	err = cur.All(ctx, &result)
	if err != nil {
		return warning.GetEquipmentStatisticsResponse{}, fmt.Errorf("unable to parse data from from mongo. Err: %w", err)
	}

	fmt.Println(result)

	if len(result) == 0 {
		return warning.GetEquipmentStatisticsResponse{}, nil
	}

	resp := warning.GetEquipmentStatisticsResponse{
		TotalCount: result[0].TotalCount,
		ExcessPercent: warning.ExcessPercentAll{
			Max: result[0].MaxExcess,
			Min: result[0].MinExcess,
			Avg: result[0].AvgExcess,
		},
		Duration: warning.DurationAll{
			Max:   result[0].MaxDuration / 1000,
			Min:   result[0].MinDuration / 1000,
			Avg:   result[0].AvgDuration / 1000,
			Total: result[0].TotalDuration / 1000,
		},
	}

	return resp, nil
}

func applyEquipmentStatisticsFilter(filter warning.GetEquipmentStatisticsRequest) bson.A {

	start, _ := time.Parse("2006-01-02T15:04:05Z07:00", filter.StartDate)
	end, _ := time.Parse("2006-01-02T15:04:05Z07:00", filter.EndDate)

	matchStageExpr := bson.M{
		"date":           bson.M{"$gte": start, "$lte": end},
		"excess_percent": bson.M{"$gte": filter.ExcessPercent},
	}

	if filter.Equipment != "" {
		matchStageExpr["equipment"] = filter.Equipment
	}

	matchStage := bson.M{"$match": matchStageExpr}

	projectStage := bson.M{
		"$project": bson.M{
			"excess_percent": 1,
			"duration": bson.M{
				"$subtract": bson.A{"$date_to", "$date_from"},
			},
		},
	}

	groupStage := bson.M{
		"$group": bson.M{
			"_id":            nil,
			"total_count":    bson.M{"$sum": 1},
			"max_excess":     bson.M{"$max": "$excess_percent"},
			"min_excess":     bson.M{"$min": "$excess_percent"},
			"avg_excess":     bson.M{"$avg": "$excess_percent"},
			"max_duration":   bson.M{"$max": "$duration"},
			"min_duration":   bson.M{"$min": "$duration"},
			"avg_duration":   bson.M{"$avg": "$duration"},
			"total_duration": bson.M{"$sum": "$duration"},
		},
	}

	return bson.A{matchStage, projectStage, groupStage}
}
