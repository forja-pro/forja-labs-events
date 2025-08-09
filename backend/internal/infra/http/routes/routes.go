package routes

import (
	"net/http"

	"github.com/forja-pro/forja-labs-posts/internal/infra/http/controller"
)

func Setup() {
	http.HandleFunc("/", controller.HelloWorld)
}