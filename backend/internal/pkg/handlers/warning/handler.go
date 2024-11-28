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
	SetViewed(ctx context.Context, viewedWarnings []domain.WarningsViewed) error
	SetDescription(ctx context.Context, username string, request domain.SetDescriptionsRequest) error
	GetStatistics(ctx context.Context, request domain.GetStatisticsRequest) (domain.GetStatisticsResponse, error)
	GetEquipmentStatistics(ctx context.Context, request domain.GetEquipmentStatisticsRequest) (domain.GetEquipmentStatisticsResponse, error)
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

	group.POST("/warnings_viewed",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.WarningsViewed,
		))

	group.POST("/add_description",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.SetDescription,
		))

	statisticsGroup := e.Group("/statistics")

	statisticsGroup.GET("/warning_statistics",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.GetStatistics,
		))

	statisticsGroup.GET("/equipment_warning_statistics",
		middleware.Authenticate(
			authentication.NewRoleSet(authentication.ROLE_ADMIN),
			h.GetEquipmentWarningStatistics,
		))
}
