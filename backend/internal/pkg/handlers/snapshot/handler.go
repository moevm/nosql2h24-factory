package snapshot

import (
	"context"
	"vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

type mongoRepo interface {
	GetAllData(ctx context.Context) (string, error)
	Truncate(ctx context.Context) error
	Insert(ctx context.Context, dataStr string) error
}

type influxRepo interface {
	GetAllRecords(ctx context.Context) (string, error)
	Insert(ctx context.Context, records *string) error
	Truncate(ctx context.Context) error
}

type Handler struct {
	mongoRepo  mongoRepo
	influxRepo influxRepo
}

func New(
	mongoRepo mongoRepo,
	influxRepo influxRepo,
) *Handler {
	return &Handler{
		mongoRepo:  mongoRepo,
		influxRepo: influxRepo,
	}
}

func (h *Handler) RouteHandler(e *echo.Echo) {
	group := e.Group("/settings")

	group.GET("/get_snapshot",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.GetSnapshot,
		))

	group.POST("/load_snapshot",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.LoadSnapshot,
		))
}
