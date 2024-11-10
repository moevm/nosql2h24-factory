package equipment

type Equipment struct {
	Key              string               `json:"key" bson:"key"`
	Name             string               `json:"name" bson:"name"`
	Details          Details              `json:"details" bson:"details"`
	Parameters       map[string]Parameter `json:"parameters" bson:"parameters"`
	WorkingParameter WorkingParameter     `json:"working_parameter" bson:"working_parameter"`
	WorkingTime      WorkingTime          `json:"working_time" bson:"working_time"`
}

type Details struct {
	Manufacturer string `json:"manufacturer" bson:"manufacturer"`
	Model        string `json:"model" bson:"model"`
	SerialNumber string `json:"SN" bson:"SN"`
	Year         int32  `json:"year" bson:"year"`
	Location     string `json:"location" bson:"location"`
	Status       string `json:"status" bson:"status"`
	Group        string `json:"group" bson:"group"`
}

type Parameter struct {
	Translate     string                  `json:"translate" bson:"translate"`
	Unit          string                  `json:"unit" bson:"unit"`
	Threshold     int32                   `json:"threshold" bson:"threshold"`
	Subparameters map[string]SubParameter `json:"subparameters" bson:"subparameters"`
}

type SubParameter struct {
	Translate string `json:"translate" bson:"translate"`
	Topic     string `json:"topic" bson:"topic"`
}

type WorkingParameter struct {
	Name      string `json:"name" bson:"name"`
	Threshold int32  `json:"threshold" bson:"threshold"`
}

type WorkingTime struct {
	Work     int32 `json:"work" bson:"work"`
	All_time int32 `json:"all_time" bson:"all_time"`
	Turn_on  int32 `json:"turn_on" bson:"turn_on"`
	Not_work int32 `json:"not_work" bson:"not_work"`
}
