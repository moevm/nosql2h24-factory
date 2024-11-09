package mongo

import (
	"context"

	"go.mongodb.org/mongo-driver/mongo"
)

type Repository struct {
	client *mongo.Client
}

func NewRepository(ctx context.Context, client *mongo.Client) *Repository {
	return &Repository{
		client: client,
	}
}
