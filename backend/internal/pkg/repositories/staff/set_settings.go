package staff

import (
	"context"
	"fmt"
	"vvnbd/internal/pkg/domain/errors"

	"go.mongodb.org/mongo-driver/bson"
)

func (r *Repository) SetSettings(ctx context.Context, username string, settings string) error {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	filter := bson.D{{Key: usernameField, Value: username}}

	update := bson.D{{Key: "$set",
		Value: bson.D{
			{Key: settingsField, Value: settings},
		},
	}}

	res, err := coll.UpdateOne(ctx, filter, update)
	if err != nil {
		return fmt.Errorf("[staff] unable to get data from mongo. Err: %w", err)
	}
	if res.ModifiedCount == 0 {
		return &errors.NotFoundError{}
	}

	return nil
}
