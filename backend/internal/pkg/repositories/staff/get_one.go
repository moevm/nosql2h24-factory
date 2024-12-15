package staff

import (
	"context"
	"fmt"
	"vvnbd/internal/pkg/domain/errors"
	domain "vvnbd/internal/pkg/domain/staff"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

func (r *Repository) GetOne(ctx context.Context, username string) (domain.PersonData, error) {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	filter := bson.D{{Key: usernameField, Value: username}}

	var result domain.PersonData
	err := coll.FindOne(ctx, filter).Decode(&result)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			return domain.PersonData{}, &errors.NotFoundError{}
		}

		return domain.PersonData{}, fmt.Errorf("[staff] unable to get data from mongo. Err: %w", err)
	}

	return result, nil
}
