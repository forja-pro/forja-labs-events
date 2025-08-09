package routes

import (
	"net/http"

	"github.com/forja-pro/forja-labs-posts/internal/infra/http/handlers"
)

func Init() {
	http.HandleFunc("GET /", handlers.HelloWorld)
}