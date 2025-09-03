package products

import (
	"database/sql"
	"fmt"
)

// Esta es la interfaz abstracta
type Repository interface {
	List() ([]Product, error)
}

// Esta es la implementación concreta (usa SQLite)
type DBRepository struct{ db *sql.DB }

// Constructor para crear la implementación
func NewDBRepository(db *sql.DB) *DBRepository {
	return &DBRepository{db: db}
}

// List devuelve hasta 5 productos con stock > 0
func (r *DBRepository) List() ([]Product, error) {
	rows, err := r.db.Query(`
		SELECT sku, title, price, currency, stock, rating
		FROM product
		WHERE stock > 0
		ORDER BY id
		LIMIT 5
	`)
	if err != nil { //Significa que no se abrió el cursor, por lo que no es necesario cerrarlo
		return nil, fmt.Errorf("Consulta de productos: %w", err)
	}

	//Acá se marca el cursor para un cierre diferido al salir de la función, sigue abierto mientras itero las rows
	defer rows.Close()

	//Acá se itera utilizando los datos ya obtenidos, con el cursor aún abierto; aunque ya se marcó para cerrar antes así que me despreocupo de eso
	out := make([]Product, 0, 5)
	for rows.Next() {
		var p Product
		if err := rows.Scan(&p.SKU, &p.Title, &p.Price, &p.Currency, &p.Stock, &p.Rating); err != nil {
			return nil, fmt.Errorf("Scan de row de producto: %w", err)
		}
		out = append(out, p)
	}

	//Si hay errores en las filas, se devuelve eso y no el resultado de productos
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("Iteración de productos: %w", err)
	}

	return out, nil
}
