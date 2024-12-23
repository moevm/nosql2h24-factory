package authentication

import (
	"context"

	"go.mongodb.org/mongo-driver/mongo"
)

const (
	usernameField     = "username"
	passwordField     = "password"
	refreshTokenField = "refresh_token"
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
