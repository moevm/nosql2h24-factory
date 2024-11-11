package warning

import "time"

type Warning struct {
	Date          time.Time `json:"date" bson:"date"`
	DateFrom      time.Time `json:"date_from" bson:"date_from"`
	DateTo        time.Time `json:"date_to" bson:"date_to"`
	Equipment     string    `json:"equipment" bson:"equipment"`
	Text          string    `json:"text" bson:"text"`
	Value         string    `json:"value" bson:"value"`
	Type          string    `json:"type" bson:"type"`
	ExcessPercent float64   `json:"excess_percent" bson:"excess_percent"`
	Viewed        bool      `json:"viewed" bson:"viewed"`
}
