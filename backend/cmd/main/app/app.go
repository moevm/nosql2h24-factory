package app

import (
	"context"
	"fmt"
	"time"
	"vvnbd/internal/config"
	"vvnbd/internal/pkg/db"
	authhandlers "vvnbd/internal/pkg/handlers/authentication"
	equipmenthandler "vvnbd/internal/pkg/handlers/equipment"
	settingshandler "vvnbd/internal/pkg/handlers/settings"
	authrepo "vvnbd/internal/pkg/repositories/authentication"
	"vvnbd/internal/pkg/repositories/equipment"
	"vvnbd/internal/pkg/repositories/logo"
	staffrepo "vvnbd/internal/pkg/repositories/staff"
	authservice "vvnbd/internal/pkg/service/authentication"
	settingsservice "vvnbd/internal/pkg/service/settings"

	"github.com/labstack/echo"
)

func RunApp(ctx context.Context, e *echo.Echo) error {
	mongoClient, err := db.NewMongoClient(ctx)
	if err != nil {
		return fmt.Errorf("unble to create mong client Err: %w", err)
	}

	dbName, err := config.GetValue(config.DatabaseName)
	if err != nil {
		return fmt.Errorf("cannot get db name from config. Err: %w", err)
	}
	usersCollection, err := config.GetValue(config.UserCollection)
	if err != nil {
		return fmt.Errorf("cannot get user collection from config. Err: %w", err)
	}

	authRepo := authrepo.NewRepository(
		ctx,
		mongoClient,
		dbName,
		usersCollection,
	)

	staffCollection, err := config.GetValue(config.StaffCollection)
	if err != nil {
		return fmt.Errorf("cannot get staff collection from config. Err: %w", err)
	}

	staffRepo := staffrepo.NewRepository(ctx, mongoClient, dbName, staffCollection)

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
		staffRepo,
		accessTokenLifetime,
		refreshTokenLifetime,
		secretKey,
	)

	logoCollection, err := config.GetValue(config.LogoCollection)
	if err != nil {
		return fmt.Errorf("cannot get logo collection from config. Err: %w", err)
	}

	logoRepo := logo.NewRepository(ctx, mongoClient, dbName, logoCollection)

	authHandler := authhandlers.NewHandler(ctx, authService, logoRepo)
	authHandler.RouteHandler(e)

	equipmentCollection, err := config.GetValue(config.EquipmentCollection)
	if err != nil {
		return fmt.Errorf("cannot get equipment collection from config. Err: %w", err)
	}

	equipmentRepo := equipment.NewRepository(ctx, mongoClient, dbName, equipmentCollection)

	equipmentHandler := equipmenthandler.NewHandler(ctx, equipmentRepo)
	equipmentHandler.RouteHandler(e)

	settingsService := settingsservice.New(ctx, staffRepo)

	settingsHandler := settingshandler.NewHandler(ctx, settingsService)
	settingsHandler.RouteHandler(e)

	// influxClient, err := db.NewInfluxClient(ctx)
	// if err != nil {
	// 	return fmt.Errorf("unable to create influx client Err: %w", err)
	// }
	return nil
}
