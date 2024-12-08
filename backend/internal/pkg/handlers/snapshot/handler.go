package snapshot

import (
	"context"
	"vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/domain/equipment"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

type equipmentRepo interface {
	GetEquipment(ctx context.Context, key string) (equipment.Equipment, error)
}

type influxRepo interface {
	GetAllRecords(ctx context.Context) (string, error)
	Insert(ctx context.Context, records *string) error
	Truncate(ctx context.Context) error
}

type Handler struct {
	equipmentRepo equipmentRepo
	influxRepo    influxRepo
}

func New(
	equipmentRepo equipmentRepo,
	influxRepo influxRepo,
) *Handler {
	return &Handler{
		equipmentRepo: equipmentRepo,
		influxRepo:    influxRepo,
	}
}

func (h *Handler) RouteHandler(e *echo.Echo) {
	group := e.Group("/snapshot")

	group.GET("/",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.GetSnapshot,
		))

	group.POST("/load",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.LoadSnapshot,
		))
}
