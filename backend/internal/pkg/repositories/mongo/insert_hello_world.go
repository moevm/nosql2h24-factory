package mongo

import (
	"context"
	"fmt"
	"vvnbd/internal/pkg/domain"
)

func (r *Repository) InsertHelloWorld(ctx context.Context, helloWorld domain.HelloWorld) error {
	coll := r.client.Database("test_base").Collection("hello_world")
	_, err := coll.InsertOne(ctx, helloWorld)
	if err != nil {
		return fmt.Errorf("unable to insert %v Err: %w", helloWorld, err)
	}

	return nil
}
