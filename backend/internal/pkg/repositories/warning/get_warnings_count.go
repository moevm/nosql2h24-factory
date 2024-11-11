package warning

import (
	"context"
	"fmt"
	"vvnbd/internal/pkg/domain/warning"

	"go.mongodb.org/mongo-driver/bson/primitive"
)

func (r *Repository) GetWarningsCount(ctx context.Context, filter warning.GetWarningsFilter) (int64, error) {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	queryFilter := applyFilter(primitive.M{}, filter)

	count, err := coll.CountDocuments(ctx, queryFilter)
	if err != nil {
		return 0, fmt.Errorf("unable to get data from mongo. Err: %w", err)
	}

	return count, nil
}
