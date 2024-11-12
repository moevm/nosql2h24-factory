package warning

import (
	"fmt"
	"net/http"
	domain "vvnbd/internal/pkg/domain/warning"
	"vvnbd/internal/pkg/middleware"

	"github.com/labstack/echo"
)

func (h *Handler) SetDescription(c echo.Context) error {
	var body domain.SetDescriptionsRequest
	err := c.Bind(&body)
	if err != nil {
		fmt.Println(err)
		return c.String(http.StatusBadRequest, "bad warnings data")
	}

	username := c.Get(middleware.ContextUsername).(string)

	err = h.service.SetDescription(c.Request().Context(), username, body)
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, struct{}{})
}
