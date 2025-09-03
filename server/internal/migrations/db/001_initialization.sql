PRAGMA foreign_keys = ON;

CREATE TABLE IF NOT EXISTS category(
  id   INTEGER PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  parent_id INTEGER REFERENCES category(id),
  CHECK (parent_id IS NULL OR parent_id <> id)
);

CREATE TABLE IF NOT EXISTS product(
  id          INTEGER PRIMARY KEY,
  sku         TEXT UNIQUE NOT NULL,
  title       TEXT NOT NULL,
  price       REAL NOT NULL,
  currency    TEXT NOT NULL DEFAULT 'UYU',
  img         TEXT,
  stock       INTEGER NOT NULL DEFAULT 0,
  rating      REAL NOT NULL DEFAULT 0 CHECK (rating BETWEEN 0 AND 5),
  category_id INTEGER NOT NULL REFERENCES category(id)
);

CREATE TABLE IF NOT EXISTS tag (
  id   INTEGER PRIMARY KEY,
  slug TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL
);

CREATE TABLE IF NOT EXISTS product_tag(
  product_id INTEGER NOT NULL REFERENCES product(id) ON DELETE CASCADE,
  tag_id     INTEGER NOT NULL REFERENCES tag(id)     ON DELETE CASCADE,
  PRIMARY KEY(product_id, tag_id)
);

DROP TABLE IF EXISTS product_fts;
CREATE VIRTUAL TABLE product_fts USING fts5(
  title,
  content = 'product',
  content_rowid = 'id',
  tokenize = "unicode61 remove_diacritics 2"
);

CREATE INDEX IF NOT EXISTS idx_product_price    	  ON product(price);
CREATE INDEX IF NOT EXISTS idx_product_instock        ON product(category_id, price) WHERE stock > 0;
CREATE INDEX IF NOT EXISTS idx_product_category 	  ON product(category_id);
CREATE INDEX IF NOT EXISTS idx_category_parent  	  ON category(parent_id);
CREATE INDEX IF NOT EXISTS idx_product_category_price ON product(category_id, price);
