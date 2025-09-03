package main

import (
	"database/sql"
	"log"
	"net/http"

	"github.com/eoliveralacuesta/generic-shop/server/internal/products"

	_ "modernc.org/sqlite"
)

func main() {
	// abrir conexión a la DB SQLite
	db, err := sql.Open("sqlite", "file:shop.db?_pragma=busy_timeout=5000")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// inyección: repo → service
	repo := products.NewDBRepository(db)
	svc := products.NewService(repo)

	// mux y mount
	mux := http.NewServeMux()
	products.Mount(mux, svc)

	log.Println("API corriendo en http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", mux))
}
