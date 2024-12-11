package mongo

import (
	"context"
	"fmt"

	"go.mongodb.org/mongo-driver/bson"
)

func (r *Repository) GetAllData(ctx context.Context) (string, error) {
	db := r.client.Database(r.databaseName)
	collections, err := db.ListCollectionNames(ctx, bson.D{})
	if err != nil {
		return "", fmt.Errorf("unable to get collections from mongo. Err: %w", err)
	}

	result := bson.M{}
	for _, collection := range collections {
		collRes := bson.A{}
		collectionClient := db.Collection(collection)
		cur, err := collectionClient.Find(ctx, bson.M{})
		if err != nil {
			return "", fmt.Errorf("unable to get data from %s mongo collection. Err: %w", collection, err)
		}

		err = cur.All(ctx, &collRes)
		if err != nil {
			return "", fmt.Errorf("unable to parse data from %s mongo collection. Err: %w", collection, err)
		}

		result[collection] = collRes
	}

	resStr, err := bson.Marshal(result)
	if err != nil {
		return "", fmt.Errorf("unable to marshal bson result. Err: %w", err)
	}

	return string(resStr), nil
}
