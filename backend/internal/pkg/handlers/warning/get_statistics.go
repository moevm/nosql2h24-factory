package warning

import (
	"fmt"
	"net/http"
	domain "vvnbd/internal/pkg/domain/warning"

	"github.com/labstack/echo"
)

func (h *Handler) GetStatistics(c echo.Context) error {
	var body domain.GetStatisticsRequest
	err := c.Bind(&body)
	if err != nil {
		fmt.Println(err)
		return c.String(http.StatusBadRequest, "bad statistics data")
	}

	result, err := h.service.GetStatistics(c.Request().Context(), body)
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, result)
}
