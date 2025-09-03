package products

type Product struct {
	SKU      string  `json:"sku"`
	Title    string  `json:"title"`
	Price    float64 `json:"price"`
	Currency string  `json:"currency"`
	Stock    int     `json:"stock"`
	Rating   float64 `json:"rating"`
}
