package warning

import (
	"fmt"
	"net/http"
	domain "vvnbd/internal/pkg/domain/warning"

	"github.com/labstack/echo"
)

func (h *Handler) WarningsViewed(c echo.Context) error {
	var body domain.SetViewedRequest
	err := c.Bind(&body)
	if err != nil {
		fmt.Println(err)
		return c.String(http.StatusBadRequest, "bad warnings data")
	}

	bodyArr := make([]domain.WarningsViewed, 0, len(body))
	for id, viewed := range body {
		bodyArr = append(bodyArr, domain.WarningsViewed{Id: id, Viewed: viewed})
	}

	err = h.service.SetViewed(c.Request().Context(), bodyArr)
	if err != nil {
		fmt.Println(err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, struct{}{})
}
