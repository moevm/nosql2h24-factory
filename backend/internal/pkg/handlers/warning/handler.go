package warning

import (
	"context"
	"vvnbd/internal/pkg/domain/authentication"
	domain "vvnbd/internal/pkg/domain/warning"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

type service interface {
	GetWarnings(ctx context.Context, request domain.GetWarningsRequest) (domain.GetWarningsResponse, error)
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
	group := e.Group("/warnings")

	group.GET("/get_warnings",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.GetWarnings,
		))
}
