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
		fmt.Println("bad message")
	}
	fmt.Println(snapshot)

	return c.JSON(http.StatusOK, struct{}{})
}
