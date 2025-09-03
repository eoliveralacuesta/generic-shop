package products

import "strings"

type Query struct {
	Q                 string
	CategorySlug      string
	Tags              []string
	Limit, Offset     int
	IncludeOutOfStock bool
}

const defaultLimit = 5
const maxLimit = 100

// Devuelve una copia con valores por defecto aplicados y texto canonizado para búsquedas
func (q Query) Normalized() Query {
	if q.Limit <= 0 {
		q.Limit = defaultLimit
	}
	if q.Limit > maxLimit {
		q.Limit = maxLimit
	}
	if q.Offset < 0 {
		q.Offset = 0
	}

	q.Q = strings.TrimSpace(q.Q)
	if q.Q != "" && !strings.HasSuffix(q.Q, "*") {
		q.Q += "*" // prefijo
	}

	return q
}
