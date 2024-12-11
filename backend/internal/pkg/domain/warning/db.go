package warning

import (
	"database/sql"
	"time"
)

type GetWarningsFilter struct {
	ExcessPercentGreatetThan sql.NullFloat64
	Equipment                sql.NullString
	LaterThan                sql.NullTime
	EalrierThan              sql.NullTime
	IsWithDescription        sql.NullBool
	IsViewed                 sql.NullBool
}

type GetWarningsOption struct {
	Limit            sql.NullInt64
	Offset           sql.NullInt64
	DateFromOrderAsc sql.NullBool
}

type GetStatisticsFilter struct {
	StartDate     time.Time
	EndDate       time.Time
	Equipment     sql.NullString
	GroupBy       string
	Metric        string
	ExcessPercent float64
}

type Statistics struct {
	StatNumber string  `bson:"_id"`
	Value      float64 `bson:"value"`
}

type EquipmentStatistics struct {
	TotalCount    int     `bson:"total_count"`
	MaxExcess     float64 `bson:"max_excess"`
	MinExcess     float64 `bson:"min_excess"`
	AvgExcess     float64 `bson:"avg_excess"`
	MaxDuration   float64 `bson:"max_duration"`
	MinDuration   float64 `bson:"min_duration"`
	AvgDuration   float64 `bson:"avg_duration"`
	TotalDuration float64 `bson:"total_duration"`
}
