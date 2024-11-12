package warning

import (
	"context"

	"go.mongodb.org/mongo-driver/mongo"
)

const (
	idField            = "_id"
	equipmentField     = "equipment"
	excessPercentField = "excess_percent"
	dateToField        = "date_to"
	dateFromField      = "date_from"
	descriptionField   = "description"
	viewedField        = "viewed"
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
