from contextlib import contextmanager
from sqlalchemy import create_engine
from ..schemas.mysql_psql_config import MySQLToPostgresConfig

# @contextmanager
# def connect_mysql(config):
#     conn_info = (
#         f"mysql+pymysql://{config['user']}:{config['password']}"
#         f"@{config['host']}:{config['port']}/{config['database']}"
#     )
#     engine = create_engine(conn_info)

#     try:
#         yield engine
#     finally:
#         engine.dispose()  # cleanup

@contextmanager
def connect_mysql(cfg: MySQLToPostgresConfig):
    conn_info = (
        f"mysql+pymysql://{cfg.mysql_user}:{cfg.mysql_password}"
        f"@{cfg.mysql_host}:{cfg.mysql_port}/{cfg.mysql_db}"
    )
    engine = create_engine(conn_info)
    try:
        yield engine
    finally:
        engine.dispose()