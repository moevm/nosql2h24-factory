package equipment

import (
	"net/http"

	"github.com/labstack/echo"
)

func (h *Handler) GetAll(c echo.Context) error {
	equipment, err := h.dao.GetAll(c.Request().Context())
	if err != nil {
		c.Echo().Logger.Errorf("cannot get equipment data. Err: %w", err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, equipment)
}
