package authentication

type Role int

const (
	ROLE_UNKNOWN Role = iota
	ROLE_ADMIN
)

var GetRole = map[string]Role{
	"":      ROLE_UNKNOWN,
	"admin": ROLE_ADMIN,
}

type UserCredentials struct {
	Username string
	Password string
}

type UserTokens struct {
	AccessToken  string
	RefreshToken string
}

type Logo struct {
	Logo string
}

type Token struct {
	Username string
	Role     Role
}
