\# 🛍️ Proyecto Go + Flutter



Demo de página con carrito enviado vía WhatsApp.



Backend: `Go`





\## ✅ Estado actual

API de productos con filtros, búsqueda y carrito vía WhatsApp



\- Endpoint \*\*GET\*\* `/products` con filtros: stock, categoría y búsqueda de texto (FTS5)

&nbsp; - Redirección 307 si se pasa un "SKU"

\- Endpoint \*\*GET\*\* `/products/{id}`

\- Endpoint \*\*GET\*\* `/products/sku/{sku}`

\- Arquitectura por capas: \*\*Handler → Service → Repository → SQLite\*\*

\- Migraciones SQLite embebidas con go:embed



---



\## Estructura del proyecto



```text

generic-shop/

├─ app/ → MÓDULO Flutter

│  └─ ...

├─ server/ → MÓDULO Go

│  ├─ go.mod → module github.com/eoliveralacuesta/generic-shop/server

│  ├─ shop.db → SQLite

│  ├─ cmd/

│  │  ├─ api/

│  │  │  └─ main.go → Arranca el servidor HTTP (:8080)

│  │  └─ migrate/

│  │     └─ main.go → Corre migraciones embebidas (idempotente)

│  └─ internal/

│     ├─ migrations/

│     │  ├─ db/

│     │  │  ├─ 001\_initialization.sql

│     │  │  ├─ 002\_seed.sql

│     │  │  ├─ 003\_product-fix.sql → corrige nombres

│     │  │  └─ 004\_product-oos.sql → marca producto sin stock

│     │  └─ embed.go → embebe migraciones SQLite

│     └─ products/

│        ├─ errors.go → enum Errors

│        ├─ query.go → struct Result (\[]Product + paginado) + normalización

│        ├─ product.go → struct Product

│        ├─ repository.go → interface Repository + DBRepository (SQLite)

│        ├─ service.go → capa intermedia para lógica de negocio + preparación de datos

│        └─ http.go → mount "/products"



```



---



\## Flujo de capas

\*\*HTTP Handler → Service → Repository → SQLite\*\*

\- \*\*Handler (`http.go`)\*\*: expone endpoints (`/products`), arma struct Query desde los parámetros de la URL y serializa JSON para frontend 

\- \*\*Service (`service.go`)\*\*: capa intermedia que utiliza normalización de struct Query y prepara los objetos para el frontend → ideal para lógica de negocio

\- \*\*Repository (`repository.go`)\*\*: ejecuta consultas sobre `shop.db`, recibe parámetros de búsqueda/filtrado con struct Query (si corresponde) y devuelve los datos con struct Product

\- \*\*DB\*\*: almacena categorías, productos y tags



---



\## Migraciones

\- \*\*001\_initialization.sql\*\* → crea tablas e índices.  

\- \*\*002\_seed.sql\*\* → carga categorías, productos y reindexa FTS.  

\- ...

\- Tabla `schema\_migrations` asegura que cada migración se aplique una sola vez





\## Ejecuciones

`go run ./cmd/migrate` → aplica 001, 002, 003...



`go run ./cmd/api` → API en http://localhost:8080



\## Ejemplos



\### Filtros disponibles

\- `q` → filtro de texto por nombre

\- `category` → filtro por categoría, incluye productos con categorías hijas

\- `oos` → incluye productos sin stock (valor = `true`) - "out of stock"

\- `limit` → límite de productos a obtener

\- `offset` → desde dónde comenzar la consulta



\### Uso 



1️⃣ Filtro por stock



`curl "http://localhost:8080/products?limit=3\&oos=true"`



\- Trae los primeros 3 productos sin importar stock



2️⃣ Búsqueda por texto (FTS5)



`curl "http://localhost:8080/products?q=vela"`



\- Devuelve productos cuyo nombre contenga `vela`

\- Por defecto límite de 5 productos



3️⃣ Filtrar por categoría



`curl "http://localhost:8080/products?category=velas"`



\- Trae productos de la categoría `velas`

\- Por defecto límite de 5 productos



4️⃣ Combinar búsqueda + categoría



`curl "http://localhost:8080/products?q=caja\&category=complementos"`



\- Trae productos de la categoría `complementos` que contengan `caja` en su nombre

\- Por defecto límite de 5 productos



5️⃣ Paginación



`curl "http://localhost:8080/products?limit=3\&offset=3"`



\- Trae 3 productos comenzando desde el cuarto producto



6️⃣ Buscar por id



`curl "http://localhost:8080/products/1"`



\- Trae el producto cuyo ID es 1



7️⃣ Buscar por SKU (redirección 307)



`curl -v "http://localhost:8080/products?q=SKU1234"`



\- Redirect 307 al endpoint `/products/sku/SKU1234`



8️⃣ Buscar por SKU



`curl "http://localhost:8080/products/sku/1234"`



\- Trae el producto cuyo SKU es `SKU1234`



9️⃣ Ejemplo de respuesta



`curl "http://localhost:8080/products?category=complementos\&offset=5"`



```json

{

&nbsp; "items": \[

&nbsp;   {

&nbsp;     "sku": "CF03",

&nbsp;     "title": "Contenedor \\"bola ocho\\" con interior forrado",

&nbsp;     "price": 390,

&nbsp;     "currency": "UYU",

&nbsp;     "stock": 12,

&nbsp;     "rating": 4.7

&nbsp;   }

&nbsp; ],

&nbsp; "total": 6,

&nbsp; "count": 1,

&nbsp; "limit": 5,

&nbsp; "offset": 5

}

```



\## Contacto

Evelyn Olivera | https://evelynolivera.dev | eolacuesta@outlook.com





