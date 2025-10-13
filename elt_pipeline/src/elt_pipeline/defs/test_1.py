from dagster import asset

@asset
def hello_asset():
    """Một asset cơ bản chỉ trả về chuỗi test."""
    return "Xin chào từ Dagster!"