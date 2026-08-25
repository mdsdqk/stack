# Video & podcasts

Subtitles and transcripts for YouTube, Bilibili, and Xiaoyuzhou Podcast.

## YouTube (yt-dlp)

### Video metadata

```bash
yt-dlp --dump-json "URL"
```

### Download subtitles

```bash
# Subtitles only (no video)
yt-dlp --write-sub --write-auto-sub --sub-lang "zh-Hans,zh,en" --skip-download -o "/tmp/%(id)s" "URL"

# Read .vtt file
cat /tmp/VIDEO_ID.*.vtt
```

### Comments

```bash
# Best-effort comments (not guaranteed complete)
yt-dlp --write-comments --skip-download --write-info-json \
  --extractor-args "youtube:max_comments=20" \
  -o "/tmp/%(id)s" "URL"
# Comments in .info.json "comments" field
```

### Search videos

```bash
yt-dlp --dump-json "ytsearch5:query"
```

> **Subtitles**: Manual uploads extract reliably; auto-generated may have duplicate lines — post-process if needed.
> **Comments**: `--write-comments` scrapes the web (not YouTube Data API); some comments may be missing.

### Subtitle retry chain (stop when you have real content)

`doctor` only confirms yt-dlp and JS runtime run; it does not fetch a specific video. `active_backend: yt-dlp` does not mean subtitles were verified for your URL.

1. Run `yt-dlp --write-sub --write-auto-sub` above.
2. On bot check, empty subtitle response, or no file — if OpenCLI is connected: `opencli youtube transcript "URL" -f yaml`.
3. If OpenCLI returns `Caption URL returned empty response`, retry up to 3 times (signed URLs expire).
4. Still failing or no subtitles: `agent-reach transcribe "URL"`.

Success = non-empty subtitle/transcript text, not exit code or doctor version probe.

### No subtitles: Whisper transcribe

```bash
agent-reach transcribe "https://www.youtube.com/watch?v=VIDEO_ID"
agent-reach transcribe ./local_audio.mp3 -o /tmp/transcript.txt
```

> `agent-reach transcribe` accepts public http(s) URLs or local audio only. For `ytsearch5:`, pick a concrete video URL from yt-dlp results first.
> Configure key: `agent-reach configure groq-key` (hidden input; free at console.groq.com) or `agent-reach configure openai-key`. Default auto mode uses the first configured provider (Groq then OpenAI) and stops on failure unless `--allow-provider-fallback` explicitly allows cross-provider fallback (may send audio to both; OpenAI may charge).

## Bilibili (bili-cli primary, OpenCLI for subtitles)

> ⚠️ **Do not use yt-dlp for Bilibili**: 412 blocks yt-dlp (latest version, direct/proxy/cookie all fail in practice). yt-dlp is for YouTube only.

### Video detail / search / hot / rank (bili-cli, read-only, no login)

```bash
bili video BVxxx
bili search "query" --type video -n 5
bili hot -n 10
bili rank -n 10
bili audio BVxxx   # audio for agent-reach transcribe when no subtitles
```

### Subtitles (OpenCLI, desktop Chrome)

```bash
opencli bilibili subtitle BVxxx
opencli bilibili search "query" -f yaml
opencli bilibili video BVxxx -f yaml
```

### Zero-config fallback: search API

```bash
UA="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36"
curl -s -c /tmp/bili_ck.txt -o /dev/null -A "$UA" "https://www.bilibili.com/"
curl -s -b /tmp/bili_ck.txt -A "$UA" -e "https://www.bilibili.com/" \
  "https://api.bilibili.com/x/web-interface/search/all/v2?keyword=QUERY&page=1"
```

> **Install bili-cli**: `pipx install bilibili-cli` (upstream unmaintained since 2026-03 but read-only works without login; `bili login` unlocks personal feeds).

## Xiaoyuzhou Podcast

### Transcribe one episode (optional `--polish` for punctuation)

```bash
~/.agent-reach/tools/xiaoyuzhou/transcribe.sh --polish "https://www.xiaoyuzhoufm.com/episode/EPISODE_ID"
```

> Whisper prompt asks for Chinese punctuation; if weak, `--polish` uses Groq Llama 3.3 70B for punctuation/paragraphs (~7s extra for a 9-minute episode). Extra LLM call — use when needed.

### Prerequisites

1. **ffmpeg**: `brew install ffmpeg`
2. **Groq API key** (free): https://console.groq.com/keys
3. **Configure**: `agent-reach configure groq-key` (hidden input)
4. **First run**: `agent-reach install --env=auto --system --channels=xiaoyuzhou` (needs explicit user approval)

### Check status

```bash
agent-reach doctor
```

> Output Markdown defaults to `/tmp/`.

## Choosing a tool

| Scenario | Tool |
|----------|------|
| YouTube subtitles | yt-dlp → OpenCLI (up to 3 tries) → agent-reach transcribe |
| Bilibili search/detail | bili-cli |
| Bilibili subtitles | opencli bilibili subtitle |
| Podcast transcribe | Xiaoyuzhou transcribe.sh |
| No subtitles | agent-reach transcribe (Bilibili: `bili audio` first) |
