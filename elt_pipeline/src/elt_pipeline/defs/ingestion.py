from ..resources.psql_context_manager import connect_psql
from ..resources.mysql_context_manager import connect_mysql
from sqlalchemy import text, inspect
import pandas as pd
from dagster import AssetKey, asset, MetadataValue
from ..schemas.mysql_psql_config import MySQLToPostgresConfig

# ====== Hàm ingestion ======
@asset(
    group_name="ingestion",
    compute_kind="python",
    key=AssetKey(["raw", "raw_cars"]),
    description="Ingest data from MySQL into PostgreSQL under the 'raw' schema.",
)
def mysql_to_postgres_raw(context, config: MySQLToPostgresConfig):
    context.log.info("🚀 Starting ingestion from MySQL → PostgreSQL...")

    all_metadata = {}

    with connect_mysql(config) as mysql_engine, connect_psql(config) as pg_engine:
        # Đảm bảo schema "raw" tồn tại
        with pg_engine.connect() as conn:
            conn.execute(text("CREATE SCHEMA IF NOT EXISTS raw"))
            conn.commit() # When use .connect()

        # Lấy danh sách bảng MySQL
        insp = inspect(mysql_engine)
        tables = config.tables or insp.get_table_names()
        context.log.info(f"📋 Tables to ingest: {tables}")

        for table in tables:
            table_name = f'raw_{table.lower()}'
            context.log.info(f"🔄 Ingesting table: {table_name}")

            # Đọc dữ liệu
            df = pd.read_sql_table(table_name=table, con=mysql_engine)
            
            # Trước khi to_sql
            with pg_engine.begin() as conn:
                conn.execute(text(f'TRUNCATE TABLE raw.{table_name}'))
                # No need commit because using .begin()

            # Ghi sang PostgreSQL
            df.to_sql(
                name=table_name,
                con=pg_engine,
                schema="raw",
                if_exists="append", # không replace nữa
                index=False,
            )

            context.log.info(f"✅ Done table: {table_name}, rows={len(df)}")

            all_metadata[table_name] = MetadataValue.int(len(df))

    context.log.info("🎉 Ingestion completed successfully.")

    # Trả metadata để hiển thị trong Dagit UI
    return all_metadata