---
name: token-optimization
description: Best practices for token usage cost reduction, prompt optimization, context window management, and efficient tool usage.
---

# Token Optimization & Cost Reduction

## Strategies & Best Practices
1. **Targeted Reading**: 
   - Use `grep` or `read` with specific `offset` and `limit` parameters instead of reading entire large files.
   - Avoid reading files or directories recursively unless necessary.
2. **Concise Outputs & Communication**:
   - Avoid verbose explanations, preambles, and conversational filler.
   - Use direct answers and structured bullet points.
3. **Context Window Management**:
   - Compact sessions regularly when context grows large.
   - Clear out completed task lists or stale outputs.
4. **Model Tiering (Small vs Frontier Models)**:
   - Use smaller/cheaper models (e.g. `small_model`) for routine tasks, formatting, code reviews, and simple checks.
   - Reserve frontier models for complex multi-step reasoning and architecture design.
5. **Tool Call Efficiency**:
   - Batch independent tool calls in parallel (e.g., searching and reading multiple files simultaneously).
   - Avoid redundant tool invocations.

## Online Resources & References
- **Anthropic Prompt Engineering & Efficiency Guide**: https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/overview
- **OpenAI Prompt Engineering Guide**: https://platform.openai.com/docs/guides/prompt-engineering
- **Model Context Protocol (MCP) Best Practices**: https://modelcontextprotocol.io

## Tool & Read Tactics
- `grep` > `read`: search symbols/paths directly; add `path`/`include` filters. Never dump a whole file to find one line.
- `read` with `offset` + `limit`: page through big files; stop when target found.
- `glob` for discovery; never recursive `ls`/`find` for file lookup.
- Batch independent tool calls in one message (parallel) — search + read + query together.
- Reuse outputs: if something was read/fetched this session, never re-read it. Cache result in the reply, not the file.
- Truncate: when a tool returns huge output, consume in slices, don't scroll it all.
- One-tool-per-goal: no redundant read-after-read, no confirm-then-do sequences.

## Context Budget & Persistence
- Watch context size; compact EARLY (before CJK/token bloat), don't wait for warning.
- Persist working state to sqlite `contexts`: decisions, file map, todo. Reload summary instead of re-deriving or re-reading.
- Clear stale rows / old insights on write; keep table lean.
- On session end (or before `compact`), write a compress summary to sqlite automatically.

## Model Tiering
- `small_model` for: terse replies, status, grep results, renames, sqlite upserts, copy edits.
- Frontier (default) for: design, debugging, multi-step reasoning, architecture.
- If a task is routine but ran on frontier, say so — don't burn frontier tokens silently.

## Output Budget
- Every reply is charged tokens. Ask "what does the user need?" then answer ONLY that.
- Never print file content back; show `path:line` or a diff.
- Elaborate only on request. If asked a yes/no, don't add context.
- Prefer tables/`path:line` lists over prose for multi-result answers.
