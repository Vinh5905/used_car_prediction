from pathlib import Path

# @definitions
# def defs():
#     return load_from_defs_folder(path_within_project=Path(__file__).parent)

from dagster import Definitions, load_assets_from_modules
from dagster_dbt import DbtCliResource
from .dbt_assets import dbt_cars_dbt_assets
from .project import dbt_cars_project
from .schedules import schedules
from .defs import ingestion

custom_assets = load_assets_from_modules([
    ingestion
])

defs = Definitions(
    assets=[
        dbt_cars_dbt_assets
    ] + custom_assets,
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=dbt_cars_project),
    },
)