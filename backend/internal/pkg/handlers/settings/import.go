package settings

import (
	"fmt"
	"net/http"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

func (h *Handler) Import(c echo.Context) error {
	username := c.Get(middleware.ContextUsername).(string)

	settings, err := h.service.GetSettings(c.Request().Context(), username)
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.String(http.StatusOK, settings)
}
