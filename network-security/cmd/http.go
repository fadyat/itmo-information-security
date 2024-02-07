package main

import (
	"log"
	"net/http"
)

const (
	httpAddr = ":8080"
)

func main() {
	s := &http.Server{
		Addr: httpAddr,
	}

	http.HandleFunc("/ping", func(w http.ResponseWriter, r *http.Request) {
		_, _ = w.Write([]byte("pong"))
		log.Println("pong")
	})

	if err := s.ListenAndServe(); err != nil {
		log.Fatal("ListenAndServe: ", err)
	}
}
