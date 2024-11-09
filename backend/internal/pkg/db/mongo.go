package db

import (
	"context"
	"fmt"
	"vvnbd/internal/config"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
	"go.mongodb.org/mongo-driver/mongo/options"
)

func NewMongoClient(ctx context.Context) (*mongo.Client, error) {
	user, err := config.GetValue(config.MongoUsername)
	if err != nil {
		return nil, fmt.Errorf("unable to get mongo user: %w", err)
	}

	password, err := config.GetValue(config.MongoPassword)
	if err != nil {
		return nil, fmt.Errorf("unable to get mongo password: %w", err)
	}

	host, err := config.GetValue(config.MongoHost)
	if err != nil {
		return nil, fmt.Errorf("unable to get mongo host: %w", err)
	}

	uri := fmt.Sprintf("mongodb://%s:%s@%s:27017/", user, password, host)

	serverAPI := options.ServerAPI(options.ServerAPIVersion1)
	opts := options.Client().ApplyURI(uri).SetServerAPIOptions(serverAPI)

	client, err := mongo.Connect(ctx, opts)
	if err != nil {
		return nil, fmt.Errorf("unable to connect to mongo Err: %w", err)
	}

	var result bson.M
	err = client.Database("admin").RunCommand(ctx, bson.D{{Key: "ping", Value: 1}}).Decode(&result)
	if err != nil {
		return nil, fmt.Errorf("mongo is unreachible Err: %w", err)
	}

	return client, nil
}
