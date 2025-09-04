# 🛍️ Proyecto Go + Flutter

Demo de página con carrito enviado vía WhatsApp.

Frontend: `Flutter`
## ✅ Estado actual

Frontend web en **Flutter** para listar productos con **búsqueda + filtros + paginación**.

- Página home de relleno
- Página de productos
  - **Filtros**: texto, categoría, incluir sin stock  
  - **URL sync** con `go_router` (q, category, oos, page)  
  - **Paginación**: “Anterior/Siguiente” con total del backend
- Página de catálogo para descargar PDF

## ⚡️ Quick start

`cd app`

`flutter pub get`

`flutter run -d web-server --web-port 8081`

## 🗂️ Estructura

```text
app/
├─ assets/                 # Recursos estáticos de la app
│  ├─ fonts/               # Tipografías
│  ├─ icons/               # Íconos
│  └─ images/              # Imágenes de UI y fondo
├─ lib/                    # Código principal de Flutter
│  ├─ body/                
│  │  ├─ modules/          
│  │  │  ├─ navbar/        # Barra de navegación global
│  │  │  └─ products/      # Grilla de productos, filtros, páginas
│  │  ├─ catalog.dart      # Catálogo con descarga de PDF
│  │  ├─ footer.dart       # Footer global
│  │  ├─ home.dart         # Página home de relleno
│  │  └─ layout.dart       # Layout base (header + content + footer)
│  ├─ models/              # Modelos de datos del backend
│  │  ├─ category.dart
│  │  ├─ product.dart
│  │  ├─ product_filter.dart
│  │  └─ product_result.dart
│  ├─ router/              # Enrutamiento y estado de navegación
│  │  ├─ router.dart
│  │  └─ router_state.dart
│  ├─ services/            # Comunicación con APIs
│  │  ├─ categories_api.dart
│  │  └─ products_api.dart
│  ├─ theme/               # Colores, tipografías y estilos globales → theme personalizado
│  └─ main.dart            
├─ web/                    # Archivos estáticos para Flutter Web
│  ├─ icons/               # Favicons
│  ├─ favicon.ico          # Favicon base
│  └─ index.html
└─ pubspec.yaml            # Dependencias y assets

```
### Filosofía
- Separar **UI** (body/modules) de **datos** (models + services) y **navegación** (router) para mantener el código escalable y fácil de mantener.
- Los módulos reutilizables permiten integrar componentes en diferentes pantallas sin duplicar código.
- La estructura refleja un flujo claro: datos → servicios → UI → navegación.

## 🔁 Flujo de búsqueda

- Cambiás filtros → **no busca** 

- Tocás **Buscar** → `onFilterChanged()` → `ProductsPage._updateFilters()`:  
  - Actualiza `filters`, `currentPage`, `offset`  
  - Actualiza la **URL** con GoRouter  
  - Llama `fetchProducts()`

- Paginación → `prev` y `next` según `currentPage` y `total`


## 🧪 Contrato con el backend

`GET /categories` → responde:  
```json
[
  { /* Category */ },
  { id, slug, name, parent },
]
```

`GET /products?...` → responde:  
```json
{  
  "items": [
    { /* Product */ }, 
    { sku, title, price, currency, img, stock, rating } 
  ],  
  "total": 42,  
  "count": 10,  
  "limit": 10,  
  "offset": 0  
}
```

## 🧯 Troubleshooting express

- Dropdown de categorías “rompe” el layout

## 🧑‍💻 Scripts útiles

`flutter clean` 

`flutter pub get`

## Contacto
Evelyn Olivera | https://evelynolivera.dev | eolacuesta@outlook.com
