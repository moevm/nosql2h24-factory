package mongo

import (
	"context"
	"fmt"

	"go.mongodb.org/mongo-driver/bson"
)

func (r *Repository) Insert(ctx context.Context, dataStr string) error {
	data := bson.M{}
	err := bson.Unmarshal([]byte(dataStr), &data)
	if err != nil {
		return fmt.Errorf("unable to parse data to mongo insert. Err: %w", err)
	}

	db := r.client.Database(r.databaseName)

	for collection, collectionData := range data {
		collectionDataArray, ok := collectionData.(bson.A)
		if !ok {
			return fmt.Errorf("unable to parse %s collection data to mongo insert", collection)
		}

		collectionClient := db.Collection(collection)
		_, err := collectionClient.InsertMany(ctx, collectionDataArray)
		if err != nil {
			return fmt.Errorf("unable to insert %s collection data to mongo insert. Err: %w", collection, err)
		}
	}

	return nil
}
