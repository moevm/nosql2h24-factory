package mongo

import (
	"context"

	"go.mongodb.org/mongo-driver/mongo"
)

type Repository struct {
	client       *mongo.Client
	databaseName string
}

func NewRepository(
	ctx context.Context,
	client *mongo.Client,
	databaseName string) *Repository {
	return &Repository{
		client:       client,
		databaseName: databaseName,
	}
}
