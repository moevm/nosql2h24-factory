package snapshot

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/labstack/echo"
)

type Snapshot struct {
	Mongo  string `json:"mongo"`
	Influx string `json:"influx"`
}

func (h *Handler) GetSnapshot(c echo.Context) error {
	str, err := h.influxRepo.GetAllRecords(c.Request().Context())
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Errorf("unable to get all influx rexcords. Err: %w", err).Error())
	}

	// h.influxRepo.Truncate(c.Request().Context())

	// h.influxRepo.Insert(c.Request().Context(), &str)

	snapshot := Snapshot{
		Mongo:  "",
		Influx: str,
	}

	c.Response().Header().Set(echo.HeaderContentType, echo.MIMEApplicationJSONCharsetUTF8)
	c.Response().WriteHeader(http.StatusOK)
	return json.NewEncoder(c.Response()).Encode(snapshot)
}
