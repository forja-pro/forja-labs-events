package main

import (
	"log"
	"os"

	"github.com/forja-pro/forja-labs-posts/config"
	"github.com/forja-pro/forja-labs-posts/internal/infra/server"
)

func main() {
	port := os.Getenv("SERVER_PORT")

	err := config.Init()
	if err != nil {
		log.Printf("Error initializing config: %s", err)
		return
	}

	db := config.GetDB()
	if db == nil {
		log.Println("Database connection is nil")
		return
	}

	log.Println("Database connection established successfully: " + db.Name())

	server.Init(port)
}
