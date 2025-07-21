import os
import psycopg2
from contextlib import contextmanager
from dotenv import load_dotenv

load_dotenv()

#variaveis do .env
DB_PARAMS = {
    "dbname":   os.getenv("DB_NAME"),
    "user":     os.getenv("DB_USER"),
    "password": os.getenv("DB_PASSWORD"),
    "host":     os.getenv("DB_HOST", "localhost"),
    "port":     os.getenv("DB_PORT", "5434")
}

# Funções de conexão ao postgres
@contextmanager
def get_conn():
    conn = psycopg2.connect(**DB_PARAMS)
    try:
        yield conn
        conn.commit()
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()

def fetch_all(query, params=None): # --> Busca todos os resultados da query
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
            return cur.fetchall()

def execute(query, params=None): # --> Executa a query
    with get_conn() as conn:
        with conn.cursor() as cur:
            cur.execute(query, params)
