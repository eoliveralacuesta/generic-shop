-- CATEGORÍAS (padre)
INSERT INTO category(slug,name) VALUES
 ('velas', 'Velas'),
 ('complementos', 'Complementos');

-- CATEGORÍAS
INSERT INTO category (slug, name, parent_id)
SELECT 'velas-aromaticas', 'Velas aromáticas', (c.id FROM category c WHERE c.slug = 'velas');
UNION ALL
SELECT 'velas-medianas', 'Velas medianas', (c.id FROM category c WHERE c.slug = 'velas');
UNION ALL
SELECT 'velas-grandes', 'Velas grandes', (c.id FROM category c WHERE c.slug = 'velas');

INSERT INTO category (slug, name, parent_id)
SELECT 'flexbox-mdf', 'Complementos flexbox', (c.id FROM category c WHERE c.slug = 'complementos');
UNION ALL
SELECT 'cajas-mdf', 'Cajas en MDF', (c.id FROM category c WHERE c.slug = 'complementos');

-- TAGS
INSERT INTO tag (slug, name) VALUES
 ('mini', 'Mini'),
 ('mediana', 'Mediana'),
 ('grande', 'Grande'),
 ('aromatica', 'Aromática'),
 ('rustica', 'Rústica'),
 ('regalo', 'Regalo'),
 ('accesorio', 'Accesorio'),
 ('madera', 'Madera');

-- PRODUCTOS
INSERT INTO product(sku, title, price, currency, img, stock, rating, category_id) VALUES
 ('VA01','Vela mini aromática 7 cm', 390, 'UYU', '/img/VA01.jpg', 12, 4.7, (SELECT id FROM category WHERE slug = 'velas-aromaticas')),
 ('V002','Vela rústica ámbar M',390,'UYU','/img/V002.jpg', 12, 4.7, (SELECT id FROM category WHERE slug = 'velas-medianas')),
 ('V003','Vela rústica ámbar M',390,'UYU','/img/V003.jpg', 12, 4.7, (SELECT id FROM category WHERE slug = 'velas-grandes')),
 
 ('CC01','Caja de 5 puntas tamaño mini', 200, 'UYU', '/img/CC01.jpg', 12, 4.7, (SELECT id FROM category WHERE slug = 'cajas-mdf')),
 ('CC02','Caja de 5 puntas tamaño mediano', 300, 'UYU', '/img/CC02.jpg', 20, 4.5, (SELECT id FROM category WHERE slug = 'cajas-mdf')),
 ('CC03','Caja de 5 puntas tamaño grande', 400, 'UYU', '/img/CC03.jpg', 8, 4.8, (SELECT id FROM category WHERE slug = 'cajas-mdf')),
 
 ('CF01','Contenedor redondo con interior forrado', 390, 'UYU', '/img/CF01.jpg', 12, 4.7, (SELECT id FROM category WHERE slug = 'flexbox-mdf')),
 ('CF02','Contenedor corazón con interior forrado', 390, 'UYU', '/img/CF02.jpg', 12, 4.7, (SELECT id FROM category WHERE slug = 'flexbox-mdf')),
 ('CF03','Contenedor "bola ocho" con interior forrado', 390, 'UYU', '/img/CF03.jpg', 12, 4.7, (SELECT id FROM category WHERE slug = 'flexbox-mdf')),
 
 ('CV01','Porta-velas en MDF', 150, 'UYU','/img/CV01.jpg', 8, 4.8, (SELECT id FROM category WHERE slug = 'complementos'));

-- REINDEXAR FTS (títulos)
INSERT INTO product_fts(rowid, title)
SELECT id, title FROM product;
