package warning

import "time"

type GetWarningsRequest struct {
	PageNum           int       `json:"page"`
	PageLen           int       `json:"per_page"`
	ExcessPercent     float64   `json:"excess_percent"`
	Equipment         string    `json:"equipment_key"`
	StartDate         time.Time `json:"start_date"`
	EndDate           time.Time `json:"end_date"`
	IsOrderASC        bool      `json:"order_ascending"`
	IsWithDescription bool      `json:"with_description"`
	Viewed            bool      `json:"viewed"`
}

type GetWarningsResponse struct {
	Warnings           []Warning `json:"warnings"`
	PageNum            int       `json:"page"`
	PageLen            int       `json:"per_page"`
	TotalWarningsCount int       `json:"total"`
	PagesCount         int       `json:"pages"`
}
