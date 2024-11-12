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

type RoleWhitelist map[Role]struct{}

func (wl RoleWhitelist) IsAllowed(role Role) bool {
	if _, ok := wl[role]; !ok {
		return false
	}
	return true
}

func NewRoleSet(roles ...Role) RoleWhitelist {
	wl := make(RoleWhitelist, len(roles))
	for _, role := range roles {
		wl[role] = struct{}{}
	}

	return wl
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
