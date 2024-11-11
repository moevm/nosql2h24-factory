package authentication

import (
	"net/http"
	domain "vvnbd/internal/pkg/domain/logo"

	"github.com/labstack/echo"
)

func (h *Handler) GetLogo(c echo.Context) error {
	logoString, err := h.logoDao.GetLogo(c.Request().Context())
	if err != nil {
		c.Echo().Logger.Errorf("cannot get logo data. Err: %w", err)
		return c.NoContent(http.StatusInternalServerError)
	}

	return c.JSON(http.StatusOK, domain.Logo{
		Logo: logoString,
	})
}
