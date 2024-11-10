package authentication

import (
	"errors"
	"net/http"
	domain "vvnbd/internal/pkg/domain/authentication"
	errs "vvnbd/internal/pkg/domain/errors"

	"github.com/labstack/echo"
)

func (h *Handler) Login(c echo.Context) error {
	var body domain.LoginRequest
	err := c.Bind(&body)
	if err != nil {
		c.Echo().Logger.Errorf("bad login data. Err: %w", err)
		return c.String(http.StatusBadRequest, "bad login data")
	}

	tokens, err := h.authService.Login(c.Request().Context(), domain.UserCredentials{
		Username: body.Username,
		Password: body.Password,
	})
	if err != nil {
		badPassErr := errs.NewAuthorizationError()
		if errors.As(err, &badPassErr) {
			return c.String(http.StatusUnauthorized, "wrong password")
		}
		c.Echo().Logger.Errorf("cannot login. Err: %w", err)
		return c.String(http.StatusInternalServerError, "cannot login")
	}

	return c.JSON(http.StatusOK, domain.LoginResponse{
		AccessToken:  tokens.AccessToken,
		RefreshToken: tokens.RefreshToken,
		Username:     body.Username,
	})
}
