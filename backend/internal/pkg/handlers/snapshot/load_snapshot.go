package snapshot

import (
	"encoding/json"
	"fmt"
	"net/http"

	"github.com/labstack/echo"
)

func (h *Handler) LoadSnapshot(c echo.Context) error {
	var body string
	c.Bind(&body)
	fmt.Println(body)

	var snapshot Snapshot
	err := json.Unmarshal([]byte(body), &snapshot)
	if err != nil {
		fmt.Println("bad message")
	}

	return c.JSON(http.StatusOK, struct{}{})
}
