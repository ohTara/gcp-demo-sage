"""Read instructions from Cloud Storage bucket."""

from sage.config import get_app_config
from sage.integrations.cloud_storage.client import get_storage_client


_INSTRUCTIONS_CACHE: str | None = None


async def get_instructions() -> str:
    """Fetch instructions from Cloud Storage, with in-memory caching.

    Returns empty string if bucket not configured or file not found.
    Only caches successful reads; failures are retried on next call.
    """
    global _INSTRUCTIONS_CACHE

    # Return cached result only if it was a successful read (not empty from failure)
    if _INSTRUCTIONS_CACHE is not None and _INSTRUCTIONS_CACHE != "__FAILED__":
        return _INSTRUCTIONS_CACHE

    config = get_app_config()
    if not config.instructions_bucket:
        return ""

    try:
        client = get_storage_client()
        bucket = client.bucket(config.instructions_bucket)
        blob = bucket.blob("istruzioni.md")

        if not blob.exists():
            return ""

        _INSTRUCTIONS_CACHE = blob.download_as_text(encoding="utf-8")
        return _INSTRUCTIONS_CACHE
    except Exception:
        # Don't cache failures - mark as failed so we retry next time
        _INSTRUCTIONS_CACHE = "__FAILED__"
        return ""