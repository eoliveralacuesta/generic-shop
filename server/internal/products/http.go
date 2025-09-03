package products

import (
	"encoding/json"
	"net/http"
)

func Mount(mux *http.ServeMux, svc *Service) {
	mux.HandleFunc("/products", func(w http.ResponseWriter, r *http.Request) {
		items, err := svc.List()
		if err != nil {
			http.Error(w, err.Error(), 500)
			return
		}
		w.Header().Set("Content-Type", "application/json")
		_ = json.NewEncoder(w).Encode(map[string]any{
			"items": items,
			"total": len(items),
		})
	})
}
