package warning

import (
	"context"
	"fmt"
	"vvnbd/internal/pkg/domain/errors"
	domain "vvnbd/internal/pkg/domain/warning"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/bson/primitive"
)

func (r *Repository) SetDescription(ctx context.Context, id string, description *domain.Description) error {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	objectId, err := primitive.ObjectIDFromHex(id)
	if err != nil {
		return fmt.Errorf("unable co convert id to object id. Err: %w", err)
	}

	filter := bson.D{{Key: idField, Value: objectId}}

	update := bson.D{{Key: "$set",
		Value: bson.D{
			{Key: descriptionField, Value: description},
		},
	}}

	res, err := coll.UpdateOne(ctx, filter, update)
	if err != nil {
		return fmt.Errorf("unable to get data from mongo. Err: %w", err)
	}
	if res.ModifiedCount == 0 {
		return &errors.NotFoundError{}
	}

	return nil
}
