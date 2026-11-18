"""Generation step of the RAG pipeline: build the grounded prompt, call the LLM."""

from pathlib import Path

from sage.domain.qa.models import Chunk
from sage.integrations.cloud_storage.instructions import get_instructions
from sage.integrations.llm.generate import generate_text

_PROMPT_TEMPLATE = (Path(__file__).parent / "prompts" / "answer_prompt.txt").read_text(
    encoding="utf-8"
)
_NO_DOCUMENTS_CONTEXT = (
    "Nessun documento disponibile (base di conoscenza non ancora popolata o non configurata)."
)


def build_prompt(question: str, chunks: list[Chunk], instructions: str) -> str:
    context = (
        "\n\n".join(f"[{chunk.source}] {chunk.text}" for chunk in chunks)
        if chunks
        else _NO_DOCUMENTS_CONTEXT
    )
    instructions_block = f"\nIstruzioni aggiuntive:\n{instructions}\n" if instructions else ""
    return _PROMPT_TEMPLATE.format(instructions=instructions_block, context=context, question=question)


async def generate_answer(question: str, chunks: list[Chunk]) -> str:
    instructions = await get_instructions()
    prompt = build_prompt(question, chunks, instructions)
    return await generate_text(prompt)
