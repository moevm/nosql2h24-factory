package authentication

import (
	"context"
	"fmt"
	"time"
	domain "vvnbd/internal/pkg/domain/authentication"
	"vvnbd/internal/pkg/domain/errors"

	"github.com/dgrijalva/jwt-go"
)

func (s *Service) Login(ctx context.Context, credentials domain.UserCredentials) (domain.UserTokens, error) {
	accessInfo, err := s.usersDao.GetUserAccessInfo(ctx, credentials.Username)
	if err != nil {
		return domain.UserTokens{}, fmt.Errorf("unable to get user access info. Err: %w", err)
	}

	if accessInfo.Password != credentials.Password {
		return domain.UserTokens{}, errors.NewAuthorizationError()
	}

	return s.generateTokens(ctx, credentials.Username)
}

func (s *Service) generateTokens(ctx context.Context, username string) (domain.UserTokens, error) {
	user, err := s.staffDao.GetOne(ctx, username)
	if err != nil {
		return domain.UserTokens{}, fmt.Errorf("unable to get user info. Err: %w", err)
	}

	role, ok := domain.GetRole[user.Role]
	if !ok {
		role = domain.ROLE_UNKNOWN
	}

	accessToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": username,
		"aud": role,
		"exp": time.Now().Add(s.accessTokenLifetime).Unix(),
		"iat": time.Now().Unix(),
	})
	signedAccessToken, err := accessToken.SignedString(s.secretKey)
	if err != nil {
		return domain.UserTokens{}, fmt.Errorf("cannot sign access token. Err: %w", err)
	}

	refreshToken := jwt.NewWithClaims(jwt.SigningMethodHS256, jwt.MapClaims{
		"sub": username,
		"exp": time.Now().Add(s.refreshTokenLifetime).Unix(),
		"iat": time.Now().Unix(),
	})
	signedRefreshToken, err := refreshToken.SignedString(s.secretKey)
	if err != nil {
		return domain.UserTokens{}, fmt.Errorf("cannot sign refresh token. Err: %w", err)
	}

	err = s.usersDao.SetRefreshToken(ctx, domain.RefreshTokenData{
		Username:     username,
		RefreshToken: signedRefreshToken,
	})
	if err != nil {
		return domain.UserTokens{}, fmt.Errorf("cannot update refresh token in db. Err: %w", err)
	}

	return domain.UserTokens{
		AccessToken:  signedAccessToken,
		RefreshToken: signedRefreshToken,
	}, nil
}
