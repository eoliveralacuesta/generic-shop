-- Fix en nombres de dos productos por SKU
UPDATE product SET title = 'Vela mediana 14 cm' WHERE sku = 'V002';
UPDATE product SET title = 'Vela grande 22 cm' WHERE sku = 'V003';

-- Rebuild del FTS para que la búsqueda refleje los cambios
INSERT INTO product_fts(product_fts) VALUES('rebuild');