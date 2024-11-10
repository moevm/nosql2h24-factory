package authentication

import (
	"context"
	"fmt"
	domain "vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/domain/errors"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

func (r *Repository) GetUserAccessInfo(ctx context.Context, username string) (domain.UserAccessInfo, error) {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	filter := bson.D{{Key: usernameField, Value: username}}

	var result domain.UserAccessInfo
	err := coll.FindOne(ctx, filter).Decode(&result)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			return domain.UserAccessInfo{}, &errors.NotFoundError{}
		}

		return domain.UserAccessInfo{}, fmt.Errorf("unable to get data from mongo. Err: %w", err)
	}

	return result, nil
}
