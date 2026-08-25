# Web reading

General web pages and RSS.

## General web (Jina Reader)

```bash
# Read any page
curl -s "https://r.jina.ai/URL"

# Example
curl -s "https://r.jina.ai/https://example.com/article"
```

**Use when**: most pages can be read directly with Jina Reader.

## Web Reader (MCP)

```bash
# Read page as Markdown
mcporter call web-reader.webReader url="https://example.com"

# Keep images
mcporter call web-reader.webReader url="https://example.com" retain_images=true

# Plain text
mcporter call web-reader.webReader url="https://example.com" return_format="text"
```

**Use when**: you need finer control over output format.

## RSS (feedparser)

```python
python3 -c "
import feedparser
for e in feedparser.parse('FEED_URL').entries[:5]:
    print(f'{e.title} — {e.link}')
"
```

**Use when**: blogs, news feeds, podcast RSS, etc.

## Choosing a tool

| Scenario | Recommended |
|----------|-------------|
| General web | Jina Reader (`curl r.jina.ai`) |
| Images / format control | web-reader MCP |
| RSS feeds | feedparser |
