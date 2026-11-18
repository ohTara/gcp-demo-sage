"""Thin async wrapper around the Gemini text-generation call.

MOCK: returns a canned string instead of calling Vertex AI. Replace with a real call to
the Google Gen AI SDK's `generate_content` (see esercizio 09_librerie_python).
"""

from sage.config import get_app_config
from sage.integrations.llm.client import get_genai_client


async def generate_text(prompt: str) -> str:
    config = get_app_config()
    client = get_genai_client()
    response = client.models.generate_content(
        model=config.chat_model,
        contents=prompt,
    )
    return response.text