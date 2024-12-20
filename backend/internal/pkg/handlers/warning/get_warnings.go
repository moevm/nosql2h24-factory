package warning

import (
	"fmt"
	"net/http"
	domain "vvnbd/internal/pkg/domain/warning"

	"github.com/labstack/echo"
)

func (h *Handler) GetWarnings(c echo.Context) error {
	var body domain.GetWarningsRequest
	err := c.Bind(&body)
	if err != nil {
		fmt.Println(err)
		return c.String(http.StatusBadRequest, "bad warnings data")
	}

	if body.PageLen == 0 {
		body.PageLen = 10
	}

	if body.PageNum == 0 {
		body.PageNum = 1
	}

	result, err := h.service.GetWarnings(c.Request().Context(), body)
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, result)
}
