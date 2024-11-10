package authentication

type UserAccessInfo struct {
	Username     string `bson:"username"`
	Password     string `bson:"password"`
	RefreshToken string `bson:"refresh_token"`
}

type RefreshTokenData struct {
	Username     string `bson:"username"`
	RefreshToken string `bson:"refresh_token"`
}
