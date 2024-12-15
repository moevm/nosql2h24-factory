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
	influxStr, err := h.influxRepo.GetAllRecords(c.Request().Context())
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Errorf("unable to get all influx records. Err: %w", err).Error())
	}

	mongoStr, err := h.mongoRepo.GetAllData(c.Request().Context())
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Errorf("unable to get all mongo records. Err: %w", err).Error())
	}

	snapshot := Snapshot{
		Mongo:  mongoStr,
		Influx: influxStr,
	}

	c.Response().Header().Set(echo.HeaderContentType, echo.MIMEApplicationJSONCharsetUTF8)
	c.Response().WriteHeader(http.StatusOK)
	return json.NewEncoder(c.Response()).Encode(snapshot)
}
