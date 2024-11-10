package middleware

import (
	"net/http"
	"time"
	"vvnbd/internal/config"
	domain "vvnbd/internal/pkg/domain/authentication"

	"github.com/dgrijalva/jwt-go"
	"github.com/labstack/echo"
)

func Authenticate(allowedRoles domain.RoleWhitelist, handler func(c echo.Context) error) func(c echo.Context) error {
	return func(c echo.Context) error {
		authHeaderContenent := c.Request().Header.Get("Authorization")
		if authHeaderContenent == "" {
			return c.NoContent(http.StatusUnauthorized)
		}
		accessToken := authHeaderContenent[7:]

		key, err := config.GetValue(config.SecretKey)
		if err != nil {
			return c.NoContent(http.StatusInternalServerError)
		}

		token, err := jwt.Parse(
			accessToken,
			func(t *jwt.Token) (interface{}, error) {
				return []byte(key), nil
			})
		if err != nil {
			return c.String(http.StatusUnauthorized, "invlid access token")
		}

		if !token.Valid {
			return c.String(http.StatusUnauthorized, "invlid access token")
		}

		claims := token.Claims.(jwt.MapClaims)
		if !claims.VerifyExpiresAt(time.Now().Unix(), true) {
			return c.String(http.StatusUnauthorized, "access token expired")
		}

		userRole, ok := claims["aud"]
		if !ok {
			return c.String(http.StatusUnauthorized, "invlid access token")
		}

		role := domain.Role(userRole.(float64))
		if !ok {
			return c.String(http.StatusUnauthorized, "invlid access token")
		}

		if !allowedRoles.IsAllowed(role) {
			return c.NoContent(http.StatusForbidden)
		}

		return handler(c)
	}
}
