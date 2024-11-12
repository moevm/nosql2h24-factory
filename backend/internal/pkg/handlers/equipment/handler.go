package equipment

import (
	"context"
	"vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/domain/equipment"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

type dao interface {
	GetAll(ctx context.Context) ([]equipment.Equipment, error)
}

type Handler struct {
	dao dao
}

func NewHandler(ctx context.Context, dao dao) *Handler {
	return &Handler{
		dao: dao,
	}
}

func (h *Handler) RouteHandler(e *echo.Echo) {
	group := e.Group("/equipment")

	group.GET("/equipment_info",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.GetAll,
		))
}
