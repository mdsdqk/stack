# Social media & communities

XiaoHongShu, Twitter/X, Bilibili, V2EX, Reddit, Facebook, Instagram.

## XiaoHongShu (multi-backend)

Three backends exist. **Run `agent-reach doctor --json` first** and check xiaohongshu's `active_backend`, then use the matching command group.

### Backend A: OpenCLI (desktop preferred)

```bash
# Search notes
opencli xiaohongshu search "query" -f yaml

# Read note body + engagement (use full URL from search, including xsec_token)
opencli xiaohongshu note "NOTE_URL" -f yaml

# Comments (including nested replies)
opencli xiaohongshu comments NOTE_ID -f yaml

# Home feed
opencli xiaohongshu feed -f yaml

# User's public notes
opencli xiaohongshu user USER_ID -f yaml
```

> Requires Chrome with the OpenCLI extension. OpenCLI only uses a Chrome session the user already controls; Agent Reach does not log in or read browser cookies.
> `agent-reach configure xhs-cookies` does not inject cookies into OpenCLI.
> Without a session, do not auto-login; use backend B/C and the Cookie-Editor export flow for that backend.

### Backend B: xiaohongshu-mcp (server)

```bash
# User exports via Cookie-Editor first, then import explicitly
agent-reach configure xhs-cookies

# Read-only status check
mcporter call xiaohongshu.check_login_status --timeout 120000

# Search
mcporter call xiaohongshu.search_feeds keyword="query" --timeout 120000

# Note detail + comments (feed_id and xsec_token from search results)
mcporter call xiaohongshu.get_feed_detail feed_id="..." xsec_token="..." --timeout 120000
```

> First call may download ~150MB headless browser — always use `--timeout 120000`.
> Auth is Cookie-Editor export only; after import run `check_login_status`.
> That command saves/imports user-provided xiaohongshu.com cookies; user should confirm scope; non-xiaohongshu.com cookies are ignored.

### Backend C: xhs-cli (legacy fallback; upstream unmaintained since 2026-03)

```bash
xhs search "query"          # search
xhs read NOTE_ID_OR_URL     # read note (must use URL/ID from search, not bare note_id)
xhs comments NOTE_ID_OR_URL # comments
xhs hot                     # trending
xhs feed                    # recommendations
```

> Known unstable: `xhs user` / `xhs user-posts` / `xhs favorites` may API-error (upstream unmaintained). New installs should prefer backend A/B.

### General notes

> **Auth boundary**: Agent Reach must not log the user into XiaoHongShu or read browser cookies. OpenCLI uses only an existing Chrome session; xiaohongshu-mcp / legacy tools use Cookie-Editor export.
>
> **xsec_token**: XiaoHongShu requires xsec_token — **do not read with a bare note_id**. Flow: search/feed → use full URL/ID from results → read. Same for all backends.
>
> **Rate limits**: High-frequency requests (batch search, deep comment paging) trigger captchas; wait 2–3 seconds between calls.
>
> **Writes (post/comment/like)**: read-only recommended; xhs-cli v0.6.x writes may return 406 due to signing.

## Twitter/X (twitter-cli)

### Auth prerequisites

Cookies saved by `agent-reach configure twitter-cookies` are only for `agent-reach doctor` to check explicit credentials. `doctor` does not run upstream `twitter status` or configure the shell. Before any `twitter` command below, set in the same shell or child process:

```bash
export TWITTER_AUTH_TOKEN="..."
export TWITTER_CT0="..."
```

### Stable commands

```bash
# Home timeline (most stable)
twitter feed -n 20

# Single tweet (with replies)
twitter tweet URL_OR_ID

# Long post / X Article
twitter article URL_OR_ID

# User timeline
twitter user-posts @username -n 20

# User profile
twitter user @username
```

### Less stable commands

```bash
# Search (Twitter changes GraphQL endpoints; may 404)
twitter search "query" -n 10

# Likes (since 2024, only your own)
twitter likes
```

### Search retry chain (stop on first success)

1. Retry once: `twitter search "query" -n 10`
2. Upgrade and retry: `pipx upgrade twitter-cli && twitter search "query" -n 10`
3. OpenCLI fallback (desktop, browser session): `opencli twitter search "query" -f yaml`
4. Otherwise use stable commands: `twitter feed` / `twitter user-posts @somebody`

### Important notes

> **Install**: `pipx install twitter-cli` (v0.8.5+)
>
> **Auth**: Cookie-Editor export only, then `TWITTER_AUTH_TOKEN` + `TWITTER_CT0`; do not rely on automatic browser reads.
>
> **IP risk**: Avoid heavy use from VPS/datacenter IPs (followers/following); residential or local is safer.
>
> **OpenCLI fallback**: On desktop, `opencli twitter search/article/user-posts -f yaml` uses browser login (no cookie env vars).
>
> **Output**: Prefer `--yaml` or `--json` for agents.

## Bilibili

> ⚠️ **Do not use yt-dlp for Bilibili** (412 blocks; no reliable workaround). Use bili-cli / OpenCLI.

```bash
# Search / hot / video detail (bili-cli, read-only, no login)
bili search "query" --type video -n 5
bili hot -n 10
bili video BVxxx

# Subtitles (OpenCLI, desktop Chrome)
opencli bilibili subtitle BVxxx
```

> More commands (audio transcribe, API fallback) in [video.md](video.md).

## V2EX (public API)

No auth required.

### Hot topics

```bash
curl -s "https://www.v2ex.com/api/topics/hot.json" -H "User-Agent: agent-reach/1.0"
```

### Node topics

```bash
# node_name e.g. python, tech, jobs, qna, programmers
curl -s "https://www.v2ex.com/api/topics/show.json?node_name=python&page=1" -H "User-Agent: agent-reach/1.0"
```

### Topic detail

```bash
# topic_id from URL, e.g. https://www.v2ex.com/t/1234567
curl -s "https://www.v2ex.com/api/topics/show.json?id=TOPIC_ID" -H "User-Agent: agent-reach/1.0"
```

### Replies

```bash
curl -s "https://www.v2ex.com/api/replies/show.json?topic_id=TOPIC_ID&page=1" -H "User-Agent: agent-reach/1.0"
```

### User info

```bash
curl -s "https://www.v2ex.com/api/members/show.json?username=USERNAME" -H "User-Agent: agent-reach/1.0"
```

### Python example

```python
from agent_reach.channels.v2ex import V2EXChannel

ch = V2EXChannel()

topics = ch.get_hot_topics(limit=10)
for t in topics:
    print(f"[{t['node_title']}] {t['title']} ({t['replies']} replies)")

node_topics = ch.get_node_topics("python", limit=5)

topic = ch.get_topic(1234567)
print(topic["title"], "—", topic["author"])

user = ch.get_user("Livid")
```

> **Node list**: https://www.v2ex.com/planes

## Reddit (multi-backend, login required)

**No zero-config path**: anonymous `.json` is blocked (403); official API needs approval since 2025-11. Both backends need login — run `agent-reach doctor --json` for reddit's `active_backend`. Mainland China may need a proxy.

### Backend A: OpenCLI (desktop, browser session)

```bash
opencli reddit search "query" -f yaml
opencli reddit read POST_ID -f yaml
opencli reddit subreddit LocalLLaMA -f yaml
opencli reddit hot -f yaml
opencli reddit popular -f yaml
opencli reddit subreddit-info LocalLLaMA -f yaml
```

> Chrome open and logged into reddit.com.

### Backend B: rdt-cli (legacy/server; upstream unmaintained since 2026-03)

```bash
rdt search "query" --limit 10
rdt read POST_ID
rdt sub python --limit 20
rdt popular --limit 10
rdt all --limit 10
```

> **Install**: `pipx install 'git+https://github.com/public-clis/rdt-cli.git'` (PyPI lags; need v0.4.2+ from GitHub). `rdt login` before search/read (manual cookies on server — see doctor).
> Prefer `--yaml` output for agents.

### Advanced: official API + PRAW (existing credentials only)

Users with a pre-2025-11 Reddit script app can use PRAW (100 QPM free). New apps are rarely approved — do not recommend for new users.

## Facebook (OpenCLI, login required)

Uses OpenCLI and facebook.com session in Chrome. Run `agent-reach doctor --json`; `active_backend` should be `OpenCLI`. Do not default to Jina/Exa/Graph API.

```bash
opencli facebook search "query" -f yaml
opencli facebook profile zuck -f yaml
opencli facebook feed --limit 10 -f yaml
opencli facebook groups --limit 20 -f yaml
```

> Chrome + OpenCLI extension, logged into facebook.com. Groups API only lists groups visible to the account and recent activity — not arbitrary group posts/comments.

## Instagram (OpenCLI, login required)

Uses OpenCLI and instagram.com session. Run `agent-reach doctor --json`; prefer OpenCLI over instaloader (historical cookie/401/429 issues).

```bash
opencli instagram search "query" -f yaml
opencli instagram profile nasa -f yaml
opencli instagram user nasa --limit 12 -f yaml
opencli instagram explore --limit 20 -f yaml
opencli instagram saved --limit 20 -f yaml
```

> Chrome + OpenCLI, logged into instagram.com. `instagram search` is user search; for posts, resolve username then `instagram user USERNAME`. On 429 / login required, re-login in Chrome and slow down.
