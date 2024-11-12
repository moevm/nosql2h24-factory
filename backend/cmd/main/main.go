package main

import (
	"context"
	"vvnbd/cmd/main/app"

	"github.com/labstack/echo"
	"github.com/labstack/echo/middleware"
)

func main() {
	e := echo.New()
	ctx := context.Background()

	e.Use(middleware.Logger())

	e.Use(middleware.CORSWithConfig(middleware.CORSConfig{
		AllowOrigins: []string{"*"},
	}))

	err := app.RunApp(ctx, e)
	if err != nil {
		e.Logger.Fatal("unable to run application. Err:", err)
	}

	e.Logger.Fatal(e.Start(":8080"))
}
