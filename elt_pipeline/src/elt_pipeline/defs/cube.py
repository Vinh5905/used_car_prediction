import pandas as pd
from dagster import AssetKey, AssetIn, Output, asset, MetadataValue
from pathlib import Path
import atoti as tt
from atoti_jdbc import JdbcLoad
from sqlalchemy import create_engine, MetaData

from contextlib import contextmanager

@contextmanager
def connect_psql(cfg):
    conn_info = (
        f"postgresql+psycopg2://{cfg['user']}:{cfg['password']}"
        f"@{cfg['host']}:{cfg['port']}/{cfg['db']}"
    )
    engine = create_engine(conn_info)
    try:
        yield engine
    finally:
        engine.dispose()

# ===============================================
# 1️⃣ Thông tin kết nối PostgreSQL
# ===============================================
POSTGRES = {
    "host": "localhost",
    "port": 5433,
    "db": "cars",
    "user": "admin",
    "password": "admin123",
}

# Chuỗi kết nối JDBC — phải có prefix "jdbc:postgresql://"
postgres_url = (
    f"jdbc:postgresql://{POSTGRES['host']}:{POSTGRES['port']}/{POSTGRES['db']}?"
    f"user={POSTGRES['user']}&password={POSTGRES['password']}"
)

# --- Tạo dict bảng với primary key do mình tự gán ---
# Ví dụ: tables_pk = {"fact_sales": "sales_id", "dim_customer": "customer_id"}
tables_pk = {
    "dim_car_details": "car_details_id",
    "dim_car_general": "car_general_id",
    "dim_car_specs": "car_specs_id",
    "dim_date": "date_id",
    "fact_car_listing": "id"
}

dim_tables = {
    "dim_car_details": "car_details_id",
    "dim_car_general": "car_general_id",
    "dim_car_specs": "car_specs_id",
    "dim_date": "date_id"
}

# ====== Hàm create cube for analysis ======
@asset(
    # Declare explicit dependencies on dbt-produced marts (dim & fact)
    deps=[
        AssetKey(["marts", "dim_car_details"]),
        AssetKey(["marts", "dim_car_general"]),
        AssetKey(["marts", "dim_car_specs"]),
        AssetKey(["marts", "dim_date"]),
        AssetKey(["marts", "fact_car_listing"]),
    ],
    group_name="analysis",
    compute_kind="python",
    key=AssetKey(["analysis", "create_cube"]),
    description="Create data cubes for analysis purposes",
    
)
def create_data_cubes(
    context
):
    context.log.info("🚀 Starting data cube creation...")

    # Note: the input parameters above are not used directly in the function body.
    # They exist to create explicit asset dependencies on the dbt-generated
    # dimension and fact assets under the `marts` schema so Dagster schedules
    # this asset only after those assets are materialized.

    # Tạo session
    session = tt.Session.start(
        tt.SessionConfig(
            user_content_storage=Path("./atoti_content")
        )
    )

    # Kiểm tra URL app Atoti
    print('Link to Atoti app:', session.url)

    # 2️⃣ Đọc metadata của schema
    metadata = MetaData()
    with connect_psql(POSTGRES) as pg_engine:
        metadata.reflect(pg_engine, schema="marts")

    # --- Load dữ liệu vào Atoti ---
    tables = {}
    for table_fullname, table in metadata.tables.items():
        clean_name = table_fullname.split(".")[-1]  # chỉ tên bảng

        # Nếu bảng không có trong dict tables_pk thì bỏ qua
        if clean_name not in tables_pk:
            print(f"⚠️ Skipping table {clean_name}, no primary key assigned")
            continue

        pk = tables_pk[clean_name]

        query = f"SELECT * FROM {table_fullname}"  # vẫn giữ schema trong query
        jdbc_load = JdbcLoad(query=query, url=postgres_url, driver="org.postgresql.Driver")

        data_types = session.tables.infer_data_types(jdbc_load)
        context.log.info(f"Data types for table {clean_name}: {data_types}")

        # Tạo table trong Atoti
        tables[clean_name] = session.create_table(
            clean_name,
            data_types=data_types,
            keys={pk} if pk else set(),
            default_values={
                # Default values cho scalar types
                **{col_name: 0 for col_name in data_types 
                if data_types[col_name] in ["int", "long"]},
                **{col_name: 0.0 for col_name in data_types 
                if data_types[col_name] in ["float", "double"]},
                # Default values cho array types
                **{col_name: [0] for col_name in data_types 
                if data_types[col_name] in ["int[]", "long[]"]},
                **{col_name: [0.0] for col_name in data_types 
                if data_types[col_name] in ["float[]", "double[]"]},
            }
        )
        tables[clean_name].load(jdbc_load)
        context.log.info(f"✅ Loaded table: {clean_name} | PK: {pk}")
        context.log.info(tables[clean_name].head(3).sort_index())

    # --- Tạo các join giữa fact và dimension tables ---
    for dim_name, key in dim_tables.items():
        dim_table = session.tables[dim_name]
        tables['fact_car_listing'].join(dim_table, tables['fact_car_listing'][key] == dim_table[key])
    
    context.log.info("🎉 Data cube creation completed successfully.")
    context.log.info(f"Atoti app schema: \n{session.tables.schema}")

    # Tạo cube
    cube = session.create_cube(tables["fact_car_listing"], mode='no_measures')
    # Aliasing the hierarchies property to a shorter variable name because we will use it a lot.
    h = cube.hierarchies
    h.update(
        {
            ('dim_car_details', 'year'): [tables['dim_car_details']['year']],
            ('dim_date', 'day_value'): [tables['dim_date']['day_value']],
            ('dim_date', 'month_value'): [tables['dim_date']['month_value']],
            ('dim_date', 'year_value'): [tables['dim_date']['year_value']]
        }
    )

    # Update measures
    m = cube.measures
    m["price.SUM"] = tt.agg.sum(tables['fact_car_listing']["price"])
    m["price.MEAN"] = tt.agg.mean(tables['fact_car_listing']["price"])

    m["mileage.SUM"] = tt.agg.sum(tables['fact_car_listing']["mileage"])
    m["mileage.MEAN"] = tt.agg.mean(tables['fact_car_listing']["mileage"])

    return Output(
        value=session,
        metadata={
            "atoti_session_url": MetadataValue.url(session.url, label="Atoti App Link"),
            "cube_name": MetadataValue.text(cube.name),
        },
    )


# @asset(
#     group_name="analysis",
#     compute_kind="python",
#     key=AssetKey(["analysis", "close_session"]),
#     description="Close Atoti session",
# )
# def close_atoti_session(context):
#     session = context.resources.atoti_session
#     session.close()
#     context.log.info("Atoti session closed.")