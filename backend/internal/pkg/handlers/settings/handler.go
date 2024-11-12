package settings

import (
	"context"
	"vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

type service interface {
	GetSettings(ctx context.Context, username string) (string, error)
	SetUserSettings(ctx context.Context, username string, settings string) error
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
	group := e.Group("/settings")

	group.POST("/export_settings",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.Export,
		))

	group.GET("/import_settings",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.Import,
		))
}
