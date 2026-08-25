# Finance & markets

Xueqiu stock quotes, search, and trending content. Quotes may be delayed; not investment advice.

## Check status first

```bash
agent-reach doctor --json
```

When `xueqiu.active_backend` is set, use that backend; `null` only means Doctor did not run a live content check. Xueqiu needs a logged-in session or minimal cookies — do not treat HTTP 400 as "symbol does not exist."

## OpenCLI (prefer when Chrome already has a session)

```bash
# Verify login
opencli xueqiu whoami -f yaml

# Stock search and quotes
opencli xueqiu search "NVIDIA" -f yaml
opencli xueqiu stock NVDA -f yaml

# Trending content and hot stocks
opencli xueqiu hot -f yaml
opencli xueqiu hot-stock -f yaml

# All read-only commands
opencli xueqiu --help
```

OpenCLI only reuses a browser session the user already controls. Do not auto-run `opencli xueqiu login`; without a session, have the user log in in Chrome or import minimal cookies explicitly:

```bash
agent-reach configure --from-browser chrome --platform xueqiu
```

This reads and saves only `xq_a_token`, not cookies from other platforms.

## Success and failures

- Success = non-empty name, symbol, price, or content list; exit code 0 with empty fields is not success.
- HTTP 400 usually means session/cookie trouble, not a bad symbol.
- If `whoami` works but `stock`/`hot` fail, report adapter or API issues — do not assume logged out.
