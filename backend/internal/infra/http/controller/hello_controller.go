package controller

import (
	"net/http"

	"github.com/forja-pro/forja-labs-posts/internal/core/services"
)

func HelloWorld(w http.ResponseWriter, r *http.Request) {
	resp := services.HelloWorld()
	w.Write([]byte(resp))
}
