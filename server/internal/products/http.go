package products

import (
	"encoding/json"
	"errors"
	"net/http"
	"net/url"
	"strconv"
	"strings"
)

func Mount(mux *http.ServeMux, svc *Service) {
	// OBTENCIÓN DE PRODUCTOS
	mux.HandleFunc("GET /products", func(w http.ResponseWriter, r *http.Request) {
		// Si viene un SKU en los parámetros, lo redirigimos al request correcto
		if s := r.URL.Query().Get("sku"); s != "" {
			http.Redirect(w, r, "/products/sku/"+url.PathEscape(s), http.StatusTemporaryRedirect)
			return
		}

		// Armado de datos obtenidos de la URL del request
		q := Query{
			Q:                 r.URL.Query().Get("q"),
			IncludeOutOfStock: false, // por defecto solo stock > 0
			CategorySlug:      r.URL.Query().Get("category"),
		}

		if v := r.URL.Query().Get("limit"); v != "" {
			if n, err := strconv.Atoi(v); err == nil {
				q.Limit = n
			}
		}
		if v := r.URL.Query().Get("offset"); v != "" {
			if n, err := strconv.Atoi(v); err == nil {
				q.Offset = n
			}
		}

		if v := r.URL.Query().Get("oos"); v != "" {
			if b, err := strconv.ParseBool(v); err == nil {
				q.IncludeOutOfStock = b
			}
		}

		if v := r.URL.Query().Get("tags"); v != "" {
			q.Tags = strings.Split(v, ",")
		}

		// Derivación a service para obtener resultado final
		result, err := svc.Find(q)
		if err != nil {
			http.Error(w, err.Error(), http.StatusInternalServerError)
			return
		}

		// Devolución de datos con codificación apropiada
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		_ = json.NewEncoder(w).Encode(result)
	})

	// OBTENCIÓN POR ID
	mux.HandleFunc("GET /products/{id}", func(w http.ResponseWriter, r *http.Request) {
		idStr := r.PathValue("id")
		id, err := strconv.Atoi(idStr)
		if err != nil || id <= 0 {
			http.Error(w, "id inválido", http.StatusBadRequest)
			return
		}

		p, err := svc.FindByID(id)
		if err != nil {
			switch {
			case errors.Is(err, ErrInvalidID):
				http.Error(w, "request inválido", http.StatusBadRequest)
			case errors.Is(err, ErrNotFound):
				http.Error(w, "producto no encontrado", http.StatusNotFound)
			default:
				http.Error(w, err.Error(), http.StatusInternalServerError)
			}
			return
		}

		//Devolución de producto
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		_ = json.NewEncoder(w).Encode(p)
	})

	// OBTENCIÓN POR SKU
	mux.HandleFunc("GET /products/sku/{sku}", func(w http.ResponseWriter, r *http.Request) {
		sku := r.PathValue("sku")
		p, err := svc.FindBySKU(sku)
		if err != nil {
			switch {
			case errors.Is(err, ErrInvalidSKU):
				http.Error(w, "request inválido", http.StatusBadRequest)
			case errors.Is(err, ErrNotFound):
				http.Error(w, "producto no encontrado", http.StatusNotFound)
			default:
				http.Error(w, err.Error(), http.StatusInternalServerError)
			}
			return
		}

		//Devolución de producto
		w.Header().Set("Content-Type", "application/json; charset=utf-8")
		_ = json.NewEncoder(w).Encode(p)
	})
}
