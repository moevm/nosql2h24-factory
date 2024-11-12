package errors

type AuthorizationError struct{}

func (e *AuthorizationError) Error() string {
	return "invalid password"
}

func NewAuthorizationError() *AuthorizationError {
	return &AuthorizationError{}
}
