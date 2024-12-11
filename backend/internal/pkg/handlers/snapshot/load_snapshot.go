package snapshot

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/labstack/echo"
)

func (h *Handler) LoadSnapshot(c echo.Context) error {
	var snapshot Snapshot
	err := json.NewDecoder(c.Request().Body).Decode(&snapshot)
	if err != nil {
		c.JSON(http.StatusBadRequest, struct{}{})
	}

	err = h.influxRepo.Truncate(c.Request().Context())
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Errorf("unable to truncate influx. Err: %w", err).Error())
	}

	err = h.influxRepo.Insert(c.Request().Context(), &snapshot.Influx)
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Errorf("unable to insert influx data. Err: %w", err).Error())
	}

	err = h.mongoRepo.Truncate(c.Request().Context())
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Errorf("unable to truncate mongo. Err: %w", err).Error())
	}

	err = h.mongoRepo.Insert(c.Request().Context(), snapshot.Mongo)
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Errorf("unable to insert mongo data. Err: %w", err).Error())
	}

	return c.JSON(http.StatusOK, struct{}{})
}
