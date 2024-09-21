package testmongorepo

import (
	"context"
	"fmt"
	"vvnbd/internal/domain"
	"vvnbd/internal/domain/db"

	"go.mongodb.org/mongo-driver/bson"
	"go.mongodb.org/mongo-driver/mongo"
)

func (r *Repository) GetHelloWorld(ctx context.Context, login string) (domain.HelloWorld, error) {
	coll := r.client.Database("test_base").Collection("hello_world")

	filter := bson.D{{Key: "login", Value: login}}

	var result domain.HelloWorld
	err := coll.FindOne(ctx, filter).Decode(&result)

	if err != nil {
		if err == mongo.ErrNoDocuments {
			return domain.HelloWorld{}, &db.NotFoundError{}
		}

		return domain.HelloWorld{}, fmt.Errorf("unable to get  Err: %w", err)
	}

	return result, nil
}
