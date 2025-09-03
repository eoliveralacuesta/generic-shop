package main

import (
	"database/sql"
	"fmt"
	"log"
	"sort"
	"strings"

	"github.com/eoliveralacuesta/generic-shop/server/internal/migrations"

	_ "modernc.org/sqlite"
)

func main() {
	db, err := sql.Open("sqlite", "file:shop.db?_pragma=busy_timeout=5000")
	if err != nil {
		log.Fatal(err)
	}
	defer db.Close()

	// asegurar tabla de control
	_, err = db.Exec(`
	CREATE TABLE IF NOT EXISTS schema_migrations(
		id     INTEGER PRIMARY KEY AUTOINCREMENT,
		name   TEXT UNIQUE NOT NULL,
		run_at TEXT NOT NULL DEFAULT (datetime('now'))
	);`)
	if err != nil {
		log.Fatal(err)
	}

	// leer migras embebidas
	entries, err := migrations.Files.ReadDir("db")
	if err != nil {
		log.Fatal(err)
	}

	names := make([]string, 0, len(entries))
	for _, e := range entries {
		names = append(names, e.Name())
	}
	sort.Strings(names)

	// ejecutar cada .sql si no fue aplicado
	for _, fname := range names {
		var done int
		_ = db.QueryRow(`SELECT COUNT(1) FROM schema_migrations WHERE name = ?`, fname).Scan(&done)
		if done > 0 {
			fmt.Println("skip:", fname)
			continue
		}

		sqlBytes, _ := migrations.Files.ReadFile("db/" + fname)
		stmts := strings.Split(string(sqlBytes), ";")

		tx, _ := db.Begin()
		for _, s := range stmts {
			s = strings.TrimSpace(s)
			if s == "" {
				continue
			}
			if _, err := tx.Exec(s); err != nil {
				_ = tx.Rollback()
				log.Fatalf("error en %s: %v\nSQL:\n%s", fname, err, s)
			}
		}

		if _, err := tx.Exec(`INSERT INTO schema_migrations(name) VALUES (?)`, fname); err != nil {
			_ = tx.Rollback()
			log.Fatal(err)
		}
		if err := tx.Commit(); err != nil {
			log.Fatal(err)
		}
		fmt.Println("OK:", fname)
	}
}
