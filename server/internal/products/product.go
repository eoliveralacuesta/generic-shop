package products

type Product struct {
	SKU      string  `json:"sku"`
	Title    string  `json:"title"`
	Price    float64 `json:"price"`
	Currency string  `json:"currency"`
	Stock    int     `json:"stock"`
	Rating   float64 `json:"rating"`
	Image    string  `json:"img"`
}

type Category struct {
	ID     int    `json:"id"`
	Name   string `json:"name"`
	Slug   string `json:"slug"`
	Parent int    `json:"parent_id"`
}
