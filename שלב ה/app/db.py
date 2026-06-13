import psycopg2
import psycopg2.extras
from contextlib import contextmanager
from app.config import DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD


def get_connection():
    return psycopg2.connect(
        host=DB_HOST, port=DB_PORT,
        dbname=DB_NAME, user=DB_USER, password=DB_PASSWORD
    )


@contextmanager
def get_cursor(dict_cursor=True):
    conn = get_connection()
    try:
        factory = psycopg2.extras.RealDictCursor if dict_cursor else psycopg2.extensions.cursor
        with conn.cursor(cursor_factory=factory) as cur:
            yield cur
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def query(sql, params=None):
    """Run a SELECT and return all rows as list of dicts."""
    with get_cursor() as cur:
        cur.execute(sql, params)
        return list(cur.fetchall())


def query_one(sql, params=None):
    """Run a SELECT and return a single row as dict (or None)."""
    with get_cursor() as cur:
        cur.execute(sql, params)
        return cur.fetchone()


def execute(sql, params=None):
    """Run INSERT / UPDATE / DELETE. Returns rowcount."""
    with get_cursor(dict_cursor=False) as cur:
        cur.execute(sql, params)
        return cur.rowcount


def call_procedure(proc_name, params=None):
    """Call a stored procedure (no result set)."""
    with get_cursor(dict_cursor=False) as cur:
        cur.execute(f"CALL {proc_name}({', '.join(['%s'] * len(params or []))})", params or [])


def call_function_refcursor(func_name, params=None):
    """Call a function that returns a refcursor. Returns list of dicts."""
    conn = get_connection()
    try:
        conn.autocommit = False
        with conn.cursor(cursor_factory=psycopg2.extras.RealDictCursor) as cur:
            placeholders = ', '.join(['%s'] * len(params or []))
            cur.execute(f"SELECT {func_name}({placeholders})", params or [])
            cursor_name = cur.fetchone()[func_name]
            cur.execute(f'FETCH ALL FROM "{cursor_name}"')
            rows = list(cur.fetchall())
        conn.commit()
        return rows
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


def call_function_scalar(func_name, params=None):
    """Call a function that returns a scalar value."""
    with get_cursor() as cur:
        placeholders = ', '.join(['%s'] * len(params or []))
        cur.execute(f"SELECT {func_name}({placeholders}) AS result", params or [])
        row = cur.fetchone()
        return row['result'] if row else None
