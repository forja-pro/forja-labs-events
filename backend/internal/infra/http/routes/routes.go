package routes

import (
	"net/http"

	"github.com/forja-pro/forja-labs-posts/internal/infra/http/controller"
)

func Init() {
	http.HandleFunc("GET /", controller.HelloWorld)
}