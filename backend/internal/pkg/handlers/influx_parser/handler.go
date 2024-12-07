package influx_parser

import (
	"context"
	"vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/domain/equipment"
	"vvnbd/internal/pkg/middleware"

	influx "github.com/influxdata/influxdb-client-go/v2/api/query"
	"github.com/labstack/echo"
)

type equipmentRepo interface {
	GetEquipment(ctx context.Context, key string) (equipment.Equipment, error)
}

type influxRepo interface {
	AnyQuery(ctx context.Context, query string, args ...interface{}) ([]*influx.FluxRecord, error)
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
	group := e.Group("/influx_parser")

	group.POST("/live-charts",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.LiveCharts,
		))

	group.POST("/get_working_percentage",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.WorkingPercentage,
		))

	group.POST("/work_percent",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.WorkPercent,
		))
}
