package server

import (
	"fmt"
	"log"
	"net/http"
)

func Init(port string) {
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, "Hello World!\n")
	})

	log.Printf("Server started on port %s", port)
	if err := http.ListenAndServe(":"+port, nil); err != nil {
		log.Fatal(err)
	}
}