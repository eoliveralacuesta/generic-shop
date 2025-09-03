package web

import (
	"log"
	"lumbra/internal/auth"
	"net/http"
)

func Mount(mux *http.ServeMux) {
	mux.Handle("/", http.FileServer(http.Dir("static/original")))
	log.Println("Lumbra web served in /")

	mux.HandleFunc("/api/catalog", func(w http.ResponseWriter, r *http.Request) {
		token := r.URL.Query().Get("token")
		if token == "" {
			token = r.Header.Get("X-Catalog-Token")
		}

		//Si no enviaron un token entonces devuelvo 400
		if token == "" {
			http.Error(w, "bad request", http.StatusBadRequest)

			log.Println("Unauthorized entry for 'catalog.pdf' request, token is empty.")
			return
		}

		//Si enviaron un token no válido devuelvo 401
		if !auth.Validate(token) {
			http.Error(w, "unauthorized", http.StatusUnauthorized)

			log.Println("Unauthorized entry for 'catalog.pdf' request.")
			return
		}

		//Headers necesarios para la respuesta
		w.Header().Set("Content-Type", "application/pdf")
		w.Header().Set("Content-Disposition", `inline; filename="catalog.pdf"`)
		w.Header().Set("Cache-Control", "private, max-age=60")

		//Devolución del archivo privado "catalog.pdf"
		http.ServeFile(w, r, "private/catalog.pdf")

		log.Println("Delivered successfully 'catalog.pdf' file.")
	})
}
