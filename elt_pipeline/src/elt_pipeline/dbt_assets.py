from dagster import AssetExecutionContext, AssetKey
from dagster_dbt import DbtCliResource, dbt_assets, DagsterDbtTranslator
from typing import Any, Optional
from collections.abc import Mapping
from .project import dbt_cars_project
from dagster_dbt import dbt_assets, DbtCliResource
from dagster import AssetExecutionContext

# class CustomDagsterDbtTranslator(DagsterDbtTranslator):
#     def get_asset_key(self, dbt_resource_props: Mapping[str, Any]) -> AssetKey:
#         print("DBT Resource Props:", dbt_resource_props)
#         asset_key = super().get_asset_key(dbt_resource_props)

#         # Kiểm tra loại tài nguyên dbt
#         if dbt_resource_props["resource_type"] == "marts":
#             # Nếu là marts, thêm tiền tố
#             asset_key = asset_key.with_prefix("marts")

#         print("Generated AssetKey:", asset_key)

#         return asset_key

# dbt assets
@dbt_assets(
    manifest=dbt_cars_project.manifest_path,
    # dagster_dbt_translator=CustomDagsterDbtTranslator()
)
def dbt_cars_dbt_assets(context: AssetExecutionContext, dbt: DbtCliResource):
    yield from dbt.cli(["build"], context=context).stream()