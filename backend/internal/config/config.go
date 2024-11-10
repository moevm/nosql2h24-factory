package config

import (
	"fmt"
	"log"
	"os"

	"github.com/joho/godotenv"
)

type ConfigVariables string

const (
	envpath = "./.env"

	// mongo configs
	MongoUsername       = "MONGO_INITDB_ROOT_USERNAME"
	MongoPassword       = "MONGO_INITDB_ROOT_PASSWORD"
	MongoHost           = "DATABASE_HOST"
	DatabaseName        = "DATABASE_NAME"
	UserCollection      = "USER_COLLECTION"
	LogoCollection      = "LOGO_COLLECTION"
	EquipmentCollection = "EQUIPMENT_COLLECTION"

	// influx configs
	InfluxToken = "DOCKER_INFLUXDB_INIT_ADMIN_TOKEN"

	// auth configs
	AccessTokenLifetime  = "ACCESS_TOKEN_LIFETIME"
	RefreshTokenLifetime = "REFRESH_TOKEN_LIFETIME"
	SecretKey            = "SECRET_KEY"
)

func init() {
	if err := godotenv.Load(envpath); err != nil {
		log.Fatal("No .env file found")
	}
}

func GetValue(variable ConfigVariables) (string, error) {
	var (
		value string
		ok    bool
	)

	if value, ok = os.LookupEnv(string(variable)); !ok {
		return "", fmt.Errorf("cannot gen variable: %s ", variable)
	}

	return value, nil
}
