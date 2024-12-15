package mongo

import (
	"context"
	"fmt"

	"go.mongodb.org/mongo-driver/bson"
)

func (r *Repository) Truncate(ctx context.Context) error {
	db := r.client.Database(r.databaseName)
	collections, err := db.ListCollectionNames(ctx, bson.D{})
	if err != nil {
		return fmt.Errorf("unable to get collections from mongo. Err: %w", err)
	}

	for _, collection := range collections {
		collectionClient := db.Collection(collection)
		collectionClient.Drop(ctx)
	}

	return nil
}
