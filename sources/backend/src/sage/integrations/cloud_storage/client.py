"""Cloud Storage client for reading instruction files."""

from google.cloud import storage


_client: storage.Client | None = None


def get_storage_client() -> storage.Client:
    """Return a cached Cloud Storage client (uses ADC)."""
    global _client
    if _client is None:
        _client = storage.Client()
    return _client