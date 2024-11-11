package settings

import (
	"net/http"
	domain "vvnbd/internal/pkg/domain/staff"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

func (h *Handler) Export(c echo.Context) error {
	var body domain.SettingsDTO
	err := c.Bind(&body)
	if err != nil {
		c.Echo().Logger.Errorf("bad settings data. Err: %w", err)
		return c.String(http.StatusBadRequest, "bad settings data")
	}

	username := c.Get(middleware.ContextUsername).(string)

	err = h.service.SetUserSettings(c.Request().Context(), username, body.Settings)
	if err != nil {
		c.Echo().Logger.Errorf("cannot export settings. Err: %w", err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.NoContent(http.StatusOK)
}
