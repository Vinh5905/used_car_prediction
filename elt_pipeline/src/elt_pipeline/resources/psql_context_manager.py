from contextlib import contextmanager
from sqlalchemy import create_engine
from ..schemas.mysql_psql_config import MySQLToPostgresConfig

@contextmanager
def connect_psql(cfg: MySQLToPostgresConfig):
    conn_info = (
        f"postgresql+psycopg2://{cfg.postgres_user}:{cfg.postgres_password}"
        f"@{cfg.postgres_host}:{cfg.postgres_port}/{cfg.postgres_db}"
    )
    engine = create_engine(conn_info)
    try:
        yield engine
    finally:
        engine.dispose()