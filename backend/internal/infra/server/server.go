package server

import (
	"log"
	"net/http"

	"github.com/forja-pro/forja-labs-posts/internal/infra/http/routes"
)

func Init(port string) {
	routes.Setup()

	log.Printf("Server started on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}