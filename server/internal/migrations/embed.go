package migrations

import "embed"

//go:embed db/*.sql
var Files embed.FS
