package equipment

import (
	"fmt"
	"net/http"

	"github.com/labstack/echo"
)

func (h *Handler) GetAll(c echo.Context) error {
	equipment, err := h.dao.GetAll(c.Request().Context())
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, equipment)
}
