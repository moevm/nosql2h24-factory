package authentication

import (
	"net/http"
	domain "vvnbd/internal/pkg/domain/logo"

	"github.com/labstack/echo"
)

func (h *Handler) GetLogo(c echo.Context) error {
	logoString, err := h.logoDao.GetLogo(c.Request().Context())
	if err != nil {
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, domain.Logo{
		Logo: logoString,
	})
}
