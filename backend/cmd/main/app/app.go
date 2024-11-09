package app

import (
	"context"
	"fmt"
	"time"
	"vvnbd/internal/config"
	"vvnbd/internal/pkg/db"
	authhandlers "vvnbd/internal/pkg/handlers/authentication"
	testhandlers "vvnbd/internal/pkg/handlers/test_handlers"
	authrepo "vvnbd/internal/pkg/repositories/authentication"
	testinfluxrepo "vvnbd/internal/pkg/repositories/influx"
	testmongorepo "vvnbd/internal/pkg/repositories/mongo"
	authservice "vvnbd/internal/pkg/service/authentication"
	testservice "vvnbd/internal/pkg/service/test_service"

	"github.com/labstack/echo"
)

func RunApp(ctx context.Context, e *echo.Echo) error {
	mongoClient, err := db.NewMongoClient(ctx)
	if err != nil {
		return fmt.Errorf("unble to create mong client Err: %w", err)
	}

	influxClient, err := db.NewInfluxClient(ctx)
	if err != nil {
		return fmt.Errorf("unable to create influx client Err: %w", err)
	}

	dbName, err := config.GetValue(config.DatabaseName)
	if err != nil {
		return fmt.Errorf("cannot get db name from config. Err: %w", err)
	}
	usersCollection, err := config.GetValue(config.UserCollection)
	if err != nil {
		return fmt.Errorf("cannot get db name from config. Err: %w", err)
	}

	authRepo := authrepo.NewRepository(
		ctx,
		mongoClient,
		dbName,
		usersCollection,
	)

	accessTokenLifetimeString, err := config.GetValue(config.AccessTokenLifetime)
	if err != nil {
		return fmt.Errorf("cannot get access token lifetime from config. Err: %w", err)
	}
	accessTokenLifetime, err := time.ParseDuration(accessTokenLifetimeString)
	if err != nil {
		return fmt.Errorf("cannot parse access token lifetime from config. Err: %w", err)
	}

	refreshTokenLifetimeString, err := config.GetValue(config.RefreshTokenLifetime)
	if err != nil {
		return fmt.Errorf("cannot get refresh token lifetime from config. Err: %w", err)
	}
	refreshTokenLifetime, err := time.ParseDuration(refreshTokenLifetimeString)
	if err != nil {
		return fmt.Errorf("cannot parse refresh token lifetime from config. Err: %w", err)
	}

	secretKey, err := config.GetValue(config.SecretKey)
	if err != nil {
		return fmt.Errorf("cannot get secret key from config. Err: %w", err)
	}

	authService := authservice.New(
		ctx,
		authRepo,
		accessTokenLifetime,
		refreshTokenLifetime,
		secretKey,
	)

	authHandler := authhandlers.NewHandler(ctx, authService)
	authHandler.RouteHandler(e)

	mongoRepo := testmongorepo.NewRepository(ctx, mongoClient)

	influxRepo := testinfluxrepo.NewRepository(ctx, influxClient)

	service := testservice.NewService(ctx, mongoRepo, influxRepo)

	handler := testhandlers.NewHandler(ctx, service)

	e.GET("/get", handler.GetHelloWorld)
	e.GET("/set", handler.SetHelloWorld)

	return nil
}
