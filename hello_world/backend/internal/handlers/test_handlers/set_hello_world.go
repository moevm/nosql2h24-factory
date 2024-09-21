package testhandlers

import (
	"net/http"

	"github.com/labstack/echo"
)

func (h *Handler) SetHelloWorld(c echo.Context) error {
	err := h.service.SetHelloWorld(c.Request().Context())
	if err != nil {
		c.Logger().Error(err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.NoContent(http.StatusOK)
}
