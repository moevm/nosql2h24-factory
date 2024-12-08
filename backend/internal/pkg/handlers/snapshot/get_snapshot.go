package snapshot

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/labstack/echo"
)

func (h *Handler) GetSnapshot(c echo.Context) error {
	str, err := h.influxRepo.GetAllRecords(c.Request().Context())
	if err != nil {
		return c.String(http.StatusInternalServerError, fmt.Errorf("unable to get all influx rexcords. Err: %w", err).Error())
	}

	// h.influxRepo.Truncate(c.Request().Context())

	// h.influxRepo.Insert(c.Request().Context(), &str)
	reader := strings.NewReader(str)

	return c.Stream(http.StatusOK, "", reader)
}
