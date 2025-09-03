package products

import "errors"

var (
	ErrInvalidID  = errors.New("invalid id")
	ErrInvalidSKU = errors.New("invalid sku")
	ErrNotFound   = errors.New("not found")
)
