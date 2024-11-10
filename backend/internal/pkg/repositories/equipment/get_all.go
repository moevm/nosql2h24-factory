package equipment

import (
	"context"
	"fmt"
	"vvnbd/internal/pkg/domain/equipment"
)

func (r *Repository) GetAll(ctx context.Context) ([]equipment.Equipment, error) {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	cur, err := coll.Find(ctx, struct{}{})
	if err != nil {
		return nil, fmt.Errorf("unable to get data from mongo. Err: %w", err)
	}

	var result []equipment.Equipment
	err = cur.All(ctx, &result)
	if err != nil {
		return nil, fmt.Errorf("unable to parse data from from mongo. Err: %w", err)
	}

	return result, nil
}
