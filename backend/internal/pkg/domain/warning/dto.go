package warning

import "time"

type GetWarningsRequest struct {
	PageNum           int       `json:"page" query:"page"`
	PageLen           int       `json:"per_page" query:"per_page"`
	ExcessPercent     float64   `json:"excess_percent" query:"excess_percent"`
	Equipment         string    `json:"equipment_key" query:"equipment_key"`
	StartDate         time.Time `json:"start_date" query:"start_date"`
	EndDate           time.Time `json:"end_date" query:"end_date"`
	IsOrderASC        bool      `json:"order_ascending" query:"order_ascending"`
	IsWithDescription bool      `json:"with_description" query:"with_description"`
	Viewed            bool      `json:"viewed" query:"viewed"`
}

type GetWarningsResponse struct {
	Warnings           []Warning `json:"warnings"`
	PageNum            int       `json:"page"`
	PageLen            int       `json:"per_page"`
	TotalWarningsCount int       `json:"total"`
	PagesCount         int       `json:"pages"`
}

type SetDescriptionsRequest struct {
	Id          string       `json:"id" bson:"_id"`
	Description *Description `json:"description" bson:"description"`
}

type SetViewedRequest map[string]bool

type GetStatisticsRequest struct {
	StartDate     time.Time `json:"start_date"`
	EndDate       time.Time `json:"end_date"`
	Equipment     *string   `json:"equipment"`
	GroupBy       string    `json:"group_by"`
	Metric        string    `json:"metric"`
	ExcessPercent float64   `json:"excess_percent"`
}

type GetStatisticsResponse struct {
	Values []string  `bson:"x"`
	Points []float64 `bson:"y"`
}
