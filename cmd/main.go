package main

import (
	"os"
	"log/slog"

	"github.com/a-h/templ"
	"github.com/labstack/echo/v4/middleware"
	"github.com/labstack/echo/v4"

	"packagename/view/layout"
	"packagename/view/partial"
	"packagename/view"
)

func main() {
  var port string
  if len(os.Args) < 2 {
    port = ":8080"
  } else {
    port = ":" + os.Args[1]
  }
  e := echo.New()
  e.Use(middleware.Logger())

  e.Static("/static", "./static")
  e.GET("/", renderView(layout.Base(view.Index(), partial.SomeComponent())))

  slog.Info("Starting server at " + port)
  e.Logger.Fatal(e.Start(port))
}

func renderView(cmp templ.Component) func (c echo.Context) error {
  return func(c echo.Context) error {
    return cmp.Render(c.Request().Context(), c.Response().Writer)
  }
}
