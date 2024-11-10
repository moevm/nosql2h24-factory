package authentication

import (
	"context"
	"fmt"
	domain "vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/domain/errors"

	"go.mongodb.org/mongo-driver/bson"
)

func (r *Repository) SetRefreshToken(ctx context.Context, secrets domain.RefreshTokenData) error {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	filter := bson.D{{Key: usernameField, Value: secrets.Username}}

	update := bson.D{{Key: "$set",
		Value: bson.D{
			{Key: refreshTokenField, Value: secrets.RefreshToken},
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
