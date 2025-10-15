from dagster import AssetExecutionContext
from dagster_dbt import DbtCliResource, dbt_assets
from typing import Any, Optional
from collections.abc import Mapping
from .project import dbt_cars_project
from dagster_dbt import dbt_assets, DbtCliResource
from dagster import AssetExecutionContext

# dbt assets
@dbt_assets(
    manifest=dbt_cars_project.manifest_path,
)
def dbt_cars_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()