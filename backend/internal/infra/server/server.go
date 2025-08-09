package server

import (
	"log"
	"net/http"

	"github.com/forja-pro/forja-labs-posts/internal/infra/http/routes"
	"github.com/gin-gonic/gin"
)

func Init(port string) {
	r := gin.Default()
	routes.SetupRoutes(r)

	log.Printf("Server started on port %s", port)
	if err := http.ListenAndServe(":"+port, r); err != nil {
		log.Fatal(err)
	}
}
