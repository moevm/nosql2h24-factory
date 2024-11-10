package logo

import (
	"context"

	"go.mongodb.org/mongo-driver/mongo"
)

type Repository struct {
	client         *mongo.Client
	databaseName   string
	collectionName string
}

func NewRepository(
	ctx context.Context,
	client *mongo.Client,
	databaseName string,
	collectionName string) *Repository {
	return &Repository{
		client:         client,
		databaseName:   databaseName,
		collectionName: collectionName,
	}
}
