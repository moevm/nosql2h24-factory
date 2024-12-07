package equipment

import (
	"context"
	"vvnbd/internal/pkg/domain/equipment"

	"go.mongodb.org/mongo-driver/bson"
)

func (r *Repository) GetEquipment(ctx context.Context, key string) (equipment.Equipment, error) {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	var eq equipment.Equipment
	result := coll.FindOne(ctx, bson.M{"key": key})
	err := result.Decode(&eq)
	if err != nil {
		return equipment.Equipment{}, nil
	}

	return eq, nil
}
