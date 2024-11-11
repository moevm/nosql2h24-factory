package warning

import (
	"database/sql"
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
