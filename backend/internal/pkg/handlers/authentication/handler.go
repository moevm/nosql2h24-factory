package authentication

import (
	"context"
	domain "vvnbd/internal/pkg/domain/authentication"

	"github.com/labstack/echo"
)

type service interface {
	Login(ctx context.Context, credentials domain.UserCredentials) (domain.UserTokens, error)
	RefreshTokens(ctx context.Context, refresToken string) (domain.UserTokens, error)
}

type Handler struct {
	service service
}

func NewHandler(ctx context.Context, service service) *Handler {
	return &Handler{
		service: service,
	}
}

func (h *Handler) RouteHandler(e *echo.Echo) {
	group := e.Group("/auth")

	group.POST("/login", h.Login)
	group.POST("/refresh_token", h.RefreshTokens)
}
