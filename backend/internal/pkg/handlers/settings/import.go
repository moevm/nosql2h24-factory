package settings

import (
	"net/http"
	domain "vvnbd/internal/pkg/domain/staff"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

func (h *Handler) Import(c echo.Context) error {
	username := c.Get(middleware.ContextUsername).(string)

	settings, err := h.service.GetSettings(c.Request().Context(), username)
	if err != nil {
		c.Echo().Logger.Errorf("cannot import settings. Err: %w", err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, domain.SettingsDTO{
		Settings: settings,
	})
}
