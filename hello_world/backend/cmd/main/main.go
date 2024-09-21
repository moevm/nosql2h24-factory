package main

import (
	"context"
	"fmt"
	"vvnbd/internal/db"
	testhandlers "vvnbd/internal/handlers/test_handlers"
	testinfluxrepo "vvnbd/internal/repositories/test_influx_repo"
	testmongorepo "vvnbd/internal/repositories/test_mongo_repo"
	testservice "vvnbd/internal/service/test_service"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	e := echo.New()
	ctx := context.Background()

	e.Use(middleware.Logger())

	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
	}))

	e.Logger.Warn("hello")
	mongoClient, err := db.NewMongoClient(ctx)
	if err != nil {
		e.Logger.Fatal(fmt.Sprintf("unble to create mong client Err: %s", err))
	}

	influxClient := db.NewInfluxClient(ctx)

	mongoRepo := testmongorepo.NewRepository(ctx, mongoClient)

	influxRepo := testinfluxrepo.NewRepository(ctx, influxClient)

	service := testservice.NewService(ctx, mongoRepo, influxRepo)

	handler := testhandlers.NewHandler(ctx, service)

	e.GET("/get", handler.GetHelloWorld)
	e.GET("/set", handler.SetHelloWorld)

	e.Logger.Fatal(e.Start(":8080"))
}
