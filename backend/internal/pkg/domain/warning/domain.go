package warning

import "time"

type Warning struct {
	Id            string       `json:"_id" bson:"_id"`
	Date          time.Time    `json:"date" bson:"date"`
	DateFrom      time.Time    `json:"date_from" bson:"date_from"`
	DateTo        time.Time    `json:"date_to" bson:"date_to"`
	Equipment     string       `json:"equipment" bson:"equipment"`
	Text          string       `json:"text" bson:"text"`
	Value         string       `json:"value" bson:"value"`
	Type          string       `json:"type" bson:"type"`
	ExcessPercent float64      `json:"excess_percent" bson:"excess_percent"`
	Viewed        *bool        `json:"viewed,omitempty" bson:"viewed"`
	Description   *Description `json:"description,omitempty" bson:"description"`
}

type WarningsViewed struct {
	Id     string `json:"_id" bson:"_id"`
	Viewed bool   `json:"viewed" bson:"viewed"`
}

type Description struct {
	Text      string    `json:"text" bson:"text"`
	UpdatedAt time.Time `json:"updated" bson:"updated"`
	Author    string    `json:"author" bson:"author"`
}
