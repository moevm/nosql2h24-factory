package authentication

import (
	"errors"
	"fmt"
	"net/http"
	domain "vvnbd/internal/pkg/domain/authentication"
	errs "vvnbd/internal/pkg/domain/errors"

	"github.com/labstack/echo"
)

func (h *Handler) RefreshTokens(c echo.Context) error {
	refreshToken := c.Request().Header.Get("Authorization")[7:]

	tokens, err := h.authService.RefreshTokens(c.Request().Context(), refreshToken)
	if err != nil {
		badPassErr := errs.NewAuthorizationError()
		if errors.As(err, &badPassErr) {
			return c.String(http.StatusUnauthorized, "token is no longer active")
		}
		fmt.Println(err)
		return c.String(http.StatusInternalServerError, "cannot refresh token")
	}

	return c.JSON(http.StatusOK, domain.RefreshTokenResponse{
		AccessToken:  tokens.AccessToken,
		RefreshToken: tokens.RefreshToken,
	})
}
