# Search tools

Exa AI search engine.

## Exa AI search

High-quality AI search, good for technical docs, official examples, and related pages.

```bash
mcporter call exa.web_search_exa query="query" numResults=5
mcporter call exa.web_search_exa query="library API code example" numResults=5
```

### Use cases

| Scenario | Parameters |
|----------|------------|
| Web search | `web_search_exa(query: "...", numResults: 5)` |
| Technical / code material | `web_search_exa(query: "framework API example", numResults: 5)` |

> Exa MCP's `get_code_context_exa` is deprecated and not registered by default. For code questions, use `web_search_exa`; for precise repo search, use GitHub search in [dev.md](dev.md).

### Strengths

- Strong on English content and technical documentation
- Query wording can surface official docs and code examples
- High-quality results

## Compared to other search tools

| Tool | Source | Best for |
|------|--------|----------|
| Exa | agent-reach | English / technical / code search |
| Zhipu search | my-mcp-tools | Chinese search |
| GitHub search | agent-reach (dev.md) | Repos / code search |
