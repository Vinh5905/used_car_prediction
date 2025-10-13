# from pathlib import Path

# from dagster import definitions, load_from_defs_folder


# @definitions
# def defs():
#     return load_from_defs_folder(path_within_project=Path(__file__).parent)

from dagster import Definitions
from dagster_dbt import DbtCliResource
from .assets import dbt_cars_dbt_assets
from .project import dbt_cars_project
from .schedules import schedules

defs = Definitions(
    assets=[dbt_cars_dbt_assets],
    schedules=schedules,
    resources={
        "dbt": DbtCliResource(project_dir=dbt_cars_project),
    },
)