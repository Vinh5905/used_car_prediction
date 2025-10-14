from dagster import Config

class MySQLToPostgresConfig(Config):
    mysql_host: str = "localhost"
    mysql_port: int = 3306
    mysql_db: str = "cars"
    mysql_user: str = "admin"
    mysql_password: str = "admin123"

    postgres_host: str = "localhost"
    postgres_port: int = 5433
    postgres_db: str = "cars"
    postgres_user: str = "admin"
    postgres_password: str = "admin123"

    tables: list[str] | None = None  # có thể truyền ["table1", "table2"] nếu muốn