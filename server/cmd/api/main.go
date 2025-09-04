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

	// Sirve PDF bajo /assets/
	mux.Handle("/assets/", http.StripPrefix("/assets/", http.FileServer(http.Dir("static/assets"))))

	// Sirve imágenes bajo /img/
	mux.Handle("/img/", http.StripPrefix("/img/", http.FileServer(http.Dir("static/img"))))

	log.Println("API corriendo en http://localhost:8080")
	log.Fatal(http.ListenAndServe(":8080", enableCORS(mux)))
}
