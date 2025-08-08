package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/forja-pro/forja-labs-posts/config"
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

	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello World!\n")
	})

	log.Printf("Server started on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}
