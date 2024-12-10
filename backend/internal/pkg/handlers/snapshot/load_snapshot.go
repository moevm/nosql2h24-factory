package snapshot

import (
	"fmt"

	"github.com/labstack/echo"
)

func (h *Handler) LoadSnapshot(c echo.Context) error {
	var body Snapshot
	c.Bind(&body)

	fmt.Println(body)
	return nil
}
