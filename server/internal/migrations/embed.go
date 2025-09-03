package migrations

import "embed"

//go:embed db/*.sql
var Files embed.FS

//Esto empaqueta los archivos .sql en un FS virtual para poder acceder a ellos desde cmd/migrate y ejecutar las actualizaciones de BD
