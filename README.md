# 🛍️ Generic Shop - Flutter + Go

Demo de web genérica de carrito de compras, con backend en Go y frontend en Flutter.

---

## Tecnologías
- **Backend**: Go
- **Frontend**: Flutter
- Base de datos: SQLite

---

## Funcionalidades principales
- Navegación y visualización de productos con paginación
- Filtros por categoría, stock y búsqueda de texto
- Carrito de compras con envío vía WhatsApp

---

## Estructura general
```text
generic-shop/
├─ app/ # Flutter Web
├─ server/ # Backend Go + SQLite
├─ README.md
```

## Ejecución rápida

### Backend
```bash
cd server
go run ./cmd/migrate   # Aplica migraciones de SQLite
go run ./cmd/api       # Levanta el API en http://localhost:8080
```

### Frontend
```bash
cd app
flutter run -d web-server  # Levanta la app web
```

## Contacto
Evelyn Olivera | https://evelynolivera.dev | eolacuesta@outlook.com
