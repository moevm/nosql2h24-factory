package staff

type PersonData struct {
	Surname               string `bson:"surname"`
	Patronymic            string `bson:"patronymic"`
	Birthday              string `bson:"abirthday"`
	WorkPlace             string `bson:"work_place"`
	Position              string `bson:"position"`
	ElectricalSafetyGroup int32  `bson:"electrical_safety_group"`
	Supervisor            string `bson:"supervisor"`
	Email                 string `bson:"email"`
	PhoneNumber           string `bson:"phone_number"`
	Role                  string `bson:"role"`
	Name                  string `bson:"name"`
	Avatar                string `bson:"avatar"`
	Username              string `bson:"username"`
	Settings              string `bson:"settings"`
}
