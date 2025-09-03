package web

import (
	"net/http"
)

func Mount(mux *http.ServeMux) {
	mux.HandleFunc("/api/orders", func(w http.ResponseWriter, r *http.Request) {
		//post y enviar a whatsapp
	})
}
