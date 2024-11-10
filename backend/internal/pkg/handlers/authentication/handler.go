package authentication

import (
	"context"
	domain "vvnbd/internal/pkg/domain/authentication"

	"github.com/labstack/echo"
)

type authService interface {
	Login(ctx context.Context, credentials domain.UserCredentials) (domain.UserTokens, error)
	RefreshTokens(ctx context.Context, refresToken string) (domain.UserTokens, error)
}

type logoDao interface {
	GetLogo(ctx context.Context) (string, error)
}

type Handler struct {
	authService authService
	logoDao     logoDao
}

func NewHandler(ctx context.Context, authService authService, logoDao logoDao) *Handler {
	return &Handler{
		authService: authService,
		logoDao:     logoDao,
	}
}

func (h *Handler) RouteHandler(e *echo.Echo) {
	group := e.Group("/auth")

	group.POST("/login", h.Login)
	group.POST("/refresh_token", h.RefreshTokens)
	group.GET("/logo", h.GetLogo)
}
