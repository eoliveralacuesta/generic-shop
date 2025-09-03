package products

import (
	"database/sql"
	"errors"
	"fmt"
	"strings"
)

// Esta es la interfaz abstracta
type Repository interface {
	Count(q Query) (int, error)
	Find(q Query) ([]Product, error)
	FindByID(id int) (Product, error)
	FindBySKU(sku string) (Product, error)
}

// Esta es la implementación concreta (usa SQLite)
type DBRepository struct{ db *sql.DB }

// Constructor para crear la implementación
func NewDBRepository(db *sql.DB) *DBRepository {
	return &DBRepository{db: db}
}

// Función para reutilizar el armado de filtrados
func buildFilterParts(q Query) (from, where string, args []any) {
	var conds []string

	// Búsqueda por coincidencia de texto (FTS5)
	if q.Q != "" {
		// Subquery FTS
		from = `
			product p
			JOIN (
				SELECT rowid FROM product_fts WHERE product_fts MATCH ?
			) f ON f.rowid = p.id
		`
		args = append(args, q.Q)
	} else {
		from = "product p"
	}

	// Stock (por defecto solo stock > 0)
	if !q.IncludeOutOfStock {
		conds = append(conds, "p.stock > 0")
	}

	// Categoría por slug
	if q.CategorySlug != "" {
		conds = append(conds, `
			p.category_id IN (
				WITH RECURSIVE cat_children(id) AS (
					SELECT id FROM category WHERE slug = ?
					UNION ALL
					SELECT c.id
					FROM category c
					JOIN cat_children ch ON c.parent_id = ch.id
				)
				SELECT id FROM cat_children
			)
		`)
		args = append(args, q.CategorySlug)
	}

	// TODO: búsqueda por tags

	// Armado final de cláusula WHERE
	if len(conds) > 0 {
		where = strings.Join(conds, " AND ")
	}

	return
}

// List devuelve hasta 5 productos con stock > 0
// Para testing
// func (r *DBRepository) List(q Query) ([]Product, error) {
// 	rows, err := r.db.Query(`
// 		SELECT sku, title, price, currency, stock, rating
// 		FROM product
// 		WHERE stock > 0
// 		ORDER BY id
// 		LIMIT ? OFFSET ?`, q.Limit, q.Offset)

// 	if err != nil { //Significa que no se abrió el cursor, por lo que no es necesario cerrarlo
// 		return nil, fmt.Errorf("consulta de productos: %w", err)
// 	}

// 	//Acá se marca el cursor para un cierre diferido al salir de la función, sigue abierto mientras itero las rows
// 	defer rows.Close()

// 	//Acá se itera utilizando los datos ya obtenidos, con el cursor aún abierto; aunque ya se marcó para cerrar antes así que me despreocupo de eso
// 	out := make([]Product, 0, 5)
// 	for rows.Next() {
// 		var p Product
// 		if err := rows.Scan(&p.SKU, &p.Title, &p.Price, &p.Currency, &p.Stock, &p.Rating); err != nil {
// 			return nil, fmt.Errorf("scan row producto: %w", err)
// 		}
// 		out = append(out, p)
// 	}

// 	//Si hay errores en las filas, se devuelve eso y no el resultado de productos
// 	if err := rows.Err(); err != nil {
// 		return nil, fmt.Errorf("iteración productos: %w", err)
// 	}

// 	return out, nil
// }

// Count devuelve la cantidad total de productos con los filtros aplicados
func (r *DBRepository) Count(q Query) (int, error) {
	from, where, args := buildFilterParts(q)
	sb := strings.Builder{}
	sb.WriteString("SELECT COUNT(*) FROM ")
	sb.WriteString(from)
	if where != "" {
		sb.WriteString(" WHERE " + where)
	}
	var total int
	if err := r.db.QueryRow(sb.String(), args...).Scan(&total); err != nil {
		return 0, fmt.Errorf("count productos: %w", err)
	}
	return total, nil
}

// Find devuelve la cantidad requerida de productos con los filtros aplicados
func (r *DBRepository) Find(q Query) ([]Product, error) {
	from, where, args := buildFilterParts(q)
	sb := strings.Builder{}
	sb.WriteString(`SELECT p.sku, p.title, p.price, p.currency, p.stock, p.rating FROM `)
	sb.WriteString(from)
	if where != "" {
		sb.WriteString(" WHERE " + where + " ")
	}
	sb.WriteString("ORDER BY p.id LIMIT ? OFFSET ?")
	args = append(args, q.Limit, q.Offset)

	// Realizo consulta
	rows, err := r.db.Query(sb.String(), args...)
	if err != nil {
		return nil, fmt.Errorf("search productos: %w", err)
	}

	// Acá se marca el cursor para un cierre diferido al salir de la función, sigue abierto mientras itero las rows
	defer rows.Close()

	out := make([]Product, 0, q.Limit)
	for rows.Next() {
		var p Product
		if err := rows.Scan(&p.SKU, &p.Title, &p.Price, &p.Currency, &p.Stock, &p.Rating); err != nil {
			return nil, fmt.Errorf("scan row producto: %w", err)
		}
		out = append(out, p)
	}

	//Misma lógica de no devolver productos si ocurrió un error
	if err := rows.Err(); err != nil {
		return nil, fmt.Errorf("iteración productos: %w", err)
	}

	return out, nil
}

// Devuelve un producto a partir de su ID
func (r *DBRepository) FindByID(id int) (Product, error) {
	if id <= 0 {
		return Product{}, ErrInvalidID
	}

	row := r.db.QueryRow(`
        SELECT sku, title, price, currency, stock, rating
        FROM product WHERE id = ?`, id)

	var p Product
	if err := row.Scan(&p.SKU, &p.Title, &p.Price, &p.Currency, &p.Stock, &p.Rating); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return Product{}, ErrNotFound
		}
		return Product{}, fmt.Errorf("find by id: %w", err)
	}
	return p, nil
}

// Devuelve un producto a partir de su SKU
func (r *DBRepository) FindBySKU(sku string) (Product, error) {
	if sku == "" {
		return Product{}, ErrInvalidSKU
	}

	row := r.db.QueryRow(`
        SELECT sku, title, price, currency, stock, rating
        FROM product WHERE UPPER(sku) = UPPER(?)`, sku)

	var p Product
	if err := row.Scan(&p.SKU, &p.Title, &p.Price, &p.Currency, &p.Stock, &p.Rating); err != nil {
		if errors.Is(err, sql.ErrNoRows) {
			return Product{}, ErrNotFound
		}
		return Product{}, fmt.Errorf("find by sku: %w", err)
	}
	return p, nil
}
