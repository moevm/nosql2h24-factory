package testhandlers

import (
	"context"
	"vvnbd/internal/pkg/domain"
)

type service interface {
	GetHelloWorld(ctx context.Context) (result domain.HelloWorld, point string, isFound bool)
	SetHelloWorld(ctx context.Context) error
}

type Handler struct {
	service service
}

func NewHandler(ctx context.Context, service service) *Handler {
	return &Handler{
		service: service,
	}
}
