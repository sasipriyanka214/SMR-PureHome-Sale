"""One-time migration helper for an existing local database.db.
Run only after SUPABASE_DB_URL is configured. It preserves primary keys so
existing orders/users/products keep their relationships.
"""
import os, sqlite3
import psycopg
from psycopg import sql

SQLITE_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), "database.db")
DB_URL = os.getenv("SUPABASE_DB_URL") or os.getenv("DATABASE_URL")

TABLES = [
    "users", "categories", "dealers", "products", "flavors",
    "orders", "order_items", "primary_orders", "primary_order_items",
    "depot_stock", "inventory", "scheme_adjustments",
    "nv_scheme_categories", "nv_scheme_rules",
]

def main():
    if not os.path.exists(SQLITE_PATH):
        raise SystemExit(f"SQLite database not found: {SQLITE_PATH}")
    if not DB_URL:
        raise SystemExit("Set SUPABASE_DB_URL before running this migration.")

    src = sqlite3.connect(SQLITE_PATH)
    src.row_factory = sqlite3.Row
    dst = psycopg.connect(DB_URL)
    try:
        dst.autocommit = False
        with dst.cursor() as cur:
            for table in TABLES:
                cols = [r[1] for r in src.execute(f'PRAGMA table_info("{table}")').fetchall()]
                if not cols:
                    continue
                rows = src.execute(f'SELECT * FROM "{table}"').fetchall()
                if not rows:
                    continue
                col_sql = sql.SQL(',').join(sql.Identifier(c) for c in cols)
                placeholders = sql.SQL(',').join(sql.Placeholder() for _ in cols)
                stmt = sql.SQL('INSERT INTO {t} ({cols}) VALUES ({vals}) ON CONFLICT DO NOTHING').format(
                    t=sql.Identifier(table), cols=col_sql, vals=placeholders
                )
                for row in rows:
                    cur.execute(stmt, tuple(row[c] for c in cols))
                print(f"migrated {table}: {len(rows)} rows")

            # Keep generated IDs above the imported maximum.
            for table in TABLES:
                try:
                    cur.execute(sql.SQL("SELECT setval(pg_get_serial_sequence(%s, 'id'), COALESCE((SELECT MAX(id) FROM {}), 1), true)").format(sql.Identifier(table)), (table,))
                except Exception:
                    dst.rollback()
                    dst.autocommit = False
                    # Some tables may not have a generated id; ignore those.
        dst.commit()
        print("Migration complete.")
    except Exception:
        dst.rollback()
        raise
    finally:
        src.close(); dst.close()

if __name__ == "__main__":
    main()
