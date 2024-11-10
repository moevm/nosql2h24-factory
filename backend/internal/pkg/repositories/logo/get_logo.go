package logo

import (
	"context"
	"fmt"
	"vvnbd/internal/pkg/domain/errors"
	"vvnbd/internal/pkg/domain/logo"

	"go.mongodb.org/mongo-driver/mongo"
)

func (r *Repository) GetLogo(ctx context.Context) (string, error) {
	coll := r.client.Database(r.databaseName).Collection(r.collectionName)

	var result logo.LogoData
	err := coll.FindOne(ctx, struct{}{}).Decode(&result)
	if err != nil {
		if err == mongo.ErrNoDocuments {
			return "", &errors.NotFoundError{}
		}

		return "", fmt.Errorf("unable to get data from mongo. Err: %w", err)
	}

	return result.Logo, nil
}
