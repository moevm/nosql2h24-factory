package settings

import (
	"fmt"
	"io"
	"net/http"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

func (h *Handler) Export(c echo.Context) error {
	body, err := io.ReadAll(c.Request().Body)
	if err != nil {
		fmt.Println(err)
		return c.String(http.StatusBadRequest, "bad settings data")
	}

	username := c.Get(middleware.ContextUsername).(string)

	err = h.service.SetUserSettings(c.Request().Context(), username, string(body))
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, struct{}{})
}
