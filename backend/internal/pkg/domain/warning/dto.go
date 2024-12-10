package warning

type GetWarningsRequest struct {
	PageNum           int     `json:"page" query:"page"`
	PageLen           int     `json:"per_page" query:"per_page"`
	ExcessPercent     float64 `json:"excess_percent" query:"excess_percent"`
	Equipment         string  `json:"equipment_key" query:"equipment_key"`
	StartDate         string  `json:"start_date" query:"start_date"`
	EndDate           string  `json:"end_date" query:"end_date"`
	IsOrderASC        bool    `json:"order_ascending" query:"order_ascending"`
	IsWithDescription bool    `json:"with_description" query:"with_description"`
	Viewed            bool    `json:"viewed" query:"viewed"`
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
	StartDate     string  `json:"start_date" query:"start_date"`
	EndDate       string  `json:"end_date" query:"end_date"`
	Equipment     string  `json:"equipment" query:"equipment"`
	GroupBy       string  `json:"group_by" query:"group_by"`
	Metric        string  `json:"metric" query:"metric"`
	ExcessPercent float64 `json:"excess_percent" query:"excess_percent"`
}

type GetStatisticsResponse struct {
	Values string  `json:"x"`
	Points float64 `json:"y"`
}

type GetEquipmentStatisticsRequest struct {
	StartDate     string  `json:"start_date" query:"start_date"`
	EndDate       string  `json:"end_date" query:"end_date"`
	Equipment     string  `json:"equipment" query:"equipment"`
	ExcessPercent float64 `json:"excess_percent" query:"excess_percent"`
}

type GetEquipmentStatisticsResponse struct {
	TotalCount    int              `json:"total_count" bson:"total_count"`
	ExcessPercent ExcessPercentAll `json:"excess_percent" bson:"excess_percent"`
	Duration      DurationAll      `json:"duration" bson:"duration"`
}

type ExcessPercentAll struct {
	Max float64 `json:"max" bson:"max"`
	Min float64 `json:"min" bson:"min"`
	Avg float64 `json:"avg" bson:"avg"`
}

type DurationAll struct {
	Max   float64 `json:"max" bson:"max"`
	Min   float64 `json:"min" bson:"min"`
	Avg   float64 `json:"avg" bson:"avg"`
	Total float64 `json:"total" bson:"total"`
}
