package equipment

import (
	"net/http"

	"github.com/labstack/echo"
)

func (h *Handler) GetAll(c echo.Context) error {
	equipment, err := h.dao.GetAll(c.Request().Context())
	if err != nil {
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, equipment)
}
