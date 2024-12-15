package influx_repo

import (
	influxdb2 "github.com/influxdata/influxdb-client-go/v2"
)

type Repository struct {
	orgName    string
	bucketName string
	client     influxdb2.Client
}

func NewRepository(
	client influxdb2.Client,
	orgName string,
	bucketName string,
) *Repository {
	return &Repository{
		client:     client,
		orgName:    orgName,
		bucketName: bucketName,
	}
}
