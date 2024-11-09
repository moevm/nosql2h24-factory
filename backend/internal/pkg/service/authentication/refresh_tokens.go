package authentication

import (
	"context"
	"fmt"
	"time"
	domain "vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/domain/errors"

	"github.com/dgrijalva/jwt-go"
)

func (s *Service) RefreshTokens(ctx context.Context, refreshToken string) (domain.UserTokens, error) {
	token, err := jwt.Parse(
		refreshToken,
		func(t *jwt.Token) (interface{}, error) {
			return s.secretKey, nil
		})
	if err != nil {
		return domain.UserTokens{}, fmt.Errorf("cannot parse refresh token. Err: %w", err)
	}

	if !token.Valid {
		return domain.UserTokens{}, errors.NewAuthorizationError()
	}

	claims := token.Claims.(jwt.MapClaims)
	if !claims.VerifyExpiresAt(time.Now().Unix(), true) {
		return domain.UserTokens{}, errors.NewAuthorizationError()
	}

	username, ok := claims["sub"]
	if !ok {
		return domain.UserTokens{}, fmt.Errorf("unable to get username from token. Err: %w", err)
	}

	accessInfo, err := s.dao.GetUserAccessInfo(ctx, username.(string))
	if err != nil {
		return domain.UserTokens{}, fmt.Errorf("unable to get user access info. Err: %w", err)
	}

	if accessInfo.RefreshToken != refreshToken {
		return domain.UserTokens{}, errors.NewAuthorizationError()
	}

	return s.generateTokens(ctx, accessInfo.Username, accessInfo.Role)
}
