\# 🛍️ Proyecto Go + Flutter (Demo catálogo con carrito)



\## 🏗️ Estructura del proyecto

cmd/

&nbsp; api/        → servidor HTTP

&nbsp; migrate/    → runner de migraciones

internal/

&nbsp; products/   → modelo, repo, service, handler

&nbsp; orders/     → (futuro checkout / carrito)

&nbsp; web/        → archivos estáticos

db/migrations/

&nbsp; 001\_initialization.sql

&nbsp; 002\_seed.sql

shop.db       → base SQLite



---



\## 🔄 Flujo de capas

HTTP Handler → Service → Repository → SQLite

\- \*\*Handler (`http.go`)\*\*: expone endpoints (`/products`), serializa JSON.  

\- \*\*Service (`service.go`)\*\*: lógica de negocio (ej. filtrar stock negativo).  

\- \*\*Repository (`sqlite\_repo.go`)\*\*: SQL real sobre `shop.db`.  

\- \*\*DB\*\*: categorías, productos, tags.  



---



\## 🗄️ Migraciones

\- \*\*001\_initialization.sql\*\* → crea tablas e índices.  

\- \*\*002\_seed.sql\*\* → carga categorías, productos y reindexa FTS.  

\- Tabla `schema\_migrations` asegura que cada migración se aplique una sola vez.  





Para correrlas:

go run ./cmd/migrate



Para levantar servidor:

go run ./cmd/api



Para consultar productos por ejemplo:
curl http://localhost:8080/products







