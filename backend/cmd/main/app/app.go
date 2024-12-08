package app

import (
	"context"
	"fmt"
	"time"
	"vvnbd/internal/config"
	"vvnbd/internal/pkg/db"
	authhandlers "vvnbd/internal/pkg/handlers/authentication"
	equipmenthandler "vvnbd/internal/pkg/handlers/equipment"
	"vvnbd/internal/pkg/handlers/influx_parser"
	settingshandler "vvnbd/internal/pkg/handlers/settings"
	"vvnbd/internal/pkg/handlers/snapshot"
	warninghandler "vvnbd/internal/pkg/handlers/warning"
	authrepo "vvnbd/internal/pkg/repositories/authentication"
	"vvnbd/internal/pkg/repositories/equipment"
	influx_repo "vvnbd/internal/pkg/repositories/influx"
	"vvnbd/internal/pkg/repositories/logo"
	staffrepo "vvnbd/internal/pkg/repositories/staff"
	warningrepo "vvnbd/internal/pkg/repositories/warning"
	authservice "vvnbd/internal/pkg/service/authentication"
	settingsservice "vvnbd/internal/pkg/service/settings"
	warningservice "vvnbd/internal/pkg/service/warning"

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

	warningCollection, err := config.GetValue(config.WarningCollection)
	if err != nil {
		return fmt.Errorf("cannot get warning collection from config. Err: %w", err)
	}

	warningRepo := warningrepo.NewRepository(ctx, mongoClient, dbName, warningCollection)

	warningService := warningservice.New(ctx, warningRepo)

	warningHandler := warninghandler.NewHandler(ctx, warningService)
	warningHandler.RouteHandler(e)

	influxClient, err := db.NewInfluxClient(ctx)
	if err != nil {
		return fmt.Errorf("unable to create influx client Err: %w", err)
	}

	influxOrg, err := config.GetValue(config.InfluxOrg)
	if err != nil {
		return fmt.Errorf("cannot get influx org from config. Err: %w", err)
	}

	influxBucket, err := config.GetValue(config.InfluxBucket)
	if err != nil {
		return fmt.Errorf("cannot get influx bucket from config. Err: %w", err)
	}

	influxRepo := influx_repo.NewRepository(
		influxClient,
		influxOrg,
		influxBucket,
	)

	influxHandler := influx_parser.New(
		equipmentRepo,
		influxRepo,
	)
	influxHandler.RouteHandler(e)

	snapshotHandler := snapshot.New(equipmentRepo, influxRepo)
	snapshotHandler.RouteHandler(e)

	return nil
}
