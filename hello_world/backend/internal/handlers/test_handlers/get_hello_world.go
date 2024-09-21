package testhandlers

import (
	"net/http"
	testdto "vvnbd/internal/dto/test_dto"

	"github.com/labstack/echo"
)

func (h *Handler) GetHelloWorld(c echo.Context) error {
	res, point, isFound := h.service.GetHelloWorld(c.Request().Context())

	resp := testdto.HelloWorldFull{
		Username: res.Username,
		FullName: res.FullName,
		Login:    res.Login,
		Icon:     res.Icon,
		Point:    point,
	}

	if !isFound {
		return c.NoContent(http.StatusNotFound)
	}

	return c.JSON(http.StatusOK, resp)
}
