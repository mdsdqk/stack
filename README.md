# s3q/stack

A showcase of my personal Claude Code / agent skill setup: skills, tools, loops, and
harnesses for customized coding workflows, agent-vendor-agnostic where possible. This
is here to be looked at and borrowed from, not something I'm promoting as an install
target — if a skill here is useful to you, take it.

## Contents

### Skills (Grill Suite)

Structured interviewing and design planning tools, adapted from Matt Pocock's suite
(see [Credits](#credits)):

- **grilling** - Core interview mechanism for stress-testing plans and decisions
- **grill-me** - Interview without working directory
- **grill-with-docs** - Interview in a repo, writes to CONTEXT.md and ADRs
- **domain-modeling** - Building and maintaining domain language glossaries
- **wayfinder** - Plan work too big for one session as a map of decision tickets on an issue tracker
- **research** - Delegate reading/API-fact gathering to a background agent, captured as a repo file
- **prototype** - Build a throwaway prototype to sanity-check a state model or UI direction
- **setup-matt-pocock-skills** - Bootstrap a repo's issue tracker + domain config for wayfinder and friends

### Skills (Capabilities)

Third-party skills that grant new abilities (e.g. live internet access, writing style)
(see [Credits](#credits)):

- **agent-reach** - Multi-platform research/fetch tool (search, social, dev, web, video, finance) routed across CLIs and APIs
- **unslop** - Cut AI writing tells and add human voice to any text

## Getting Started

This repo is agent-vendor-agnostic: every skill is plain `SKILL.md` + supporting
files, nothing Claude-Code-specific required to read or reuse them.

1. Clone the repo, browse `skills/` for what you want
2. Each skill has its own SKILL.md documenting usage and prerequisites
3. To wire skills into a local agent tool that scans one directory level deep for
   `SKILL.md` (Claude Code, Codex, Cursor, `~/.agents`), run
   `scripts/link-skills.sh` (or `scripts/link-skills.ps1` on Windows) — see
   [Organization](#organization) below

Claude Code users who specifically want one-command install can instead add this
repo as a plugin marketplace source and install `s3q/stack`
(`.claude-plugin/marketplace.json` + `plugin.json` list every skill by its nested
path); this is a secondary option, not the primary way this repo is meant to be used.

For other agent tools (Codex, Cursor, plain `~/.agents`) that only scan one
directory level deep for `SKILL.md`, run `scripts/link-skills.sh` (or
`scripts/link-skills.ps1` on Windows) after cloning or pulling. It creates a flat,
per-skill symlink for every skill into `~/.claude/skills`, `~/.agents/stack-skills`,
`~/.codex/stack-skills`, and `~/.cursor/stack-skills`. Re-run it whenever a skill is
added, renamed, or removed.

## Organization

```
stack/
├── .claude-plugin/
│   ├── plugin.json       # lists every skill by its nested path (secondary, Claude-Code-only install path)
│   └── marketplace.json  # makes this repo its own installable marketplace
├── scripts/
│   ├── link-skills.sh    # flattens skills/ into each tool's flat skills dir (macOS/Linux)
│   └── link-skills.ps1   # same, for Windows
└── skills/
    ├── shared/
    │   └── grilling/      # used by both grill-me and grill-with-docs; lives here, not under either bucket
    ├── productivity/
    │   └── grill-me/
    ├── engineering/
    │   ├── grill-with-docs/
    │   ├── domain-modeling/
    │   ├── prototype/
    │   ├── research/
    │   ├── setup-matt-pocock-skills/
    │   └── wayfinder/
    └── capabilities/
        ├── agent-reach/
        └── unslop/
```

The repo itself stays nested only — no flat symlinks are committed. The flat,
one-level layout some tools require is generated locally by the link scripts above,
straight into each tool's home-directory skills folder, and is never tracked in git
(the generated symlinks point at absolute local paths, so committing them would
break on any other machine or clone location).

**On Windows**, always create these symlinks with PowerShell
(`New-Item -ItemType SymbolicLink`, i.e. `scripts/link-skills.ps1`), not `ln -s` in
Git Bash — the latter has been observed to silently fall back to a real recursive
copy instead of a symlink, which desyncs the flattened copy from the source
directory.

## Customization

This is a living collection—add, modify, and refine skills to match your personal preferences and coding workflows. Consider adding:

- Custom harnesses for your projects
- Personalized variations of existing skills
- New skills and tools you develop
- Workflow automation loops

## Credits

This repo adapts skills built by others. Full license text for each is in
[THIRD_PARTY_NOTICES.md](./THIRD_PARTY_NOTICES.md).

- **grilling, grill-me, grill-with-docs, domain-modeling, wayfinder, research,
  prototype, setup-matt-pocock-skills** — adapted from
  [Matt Pocock's Skills Suite](https://github.com/mattpocock/skills) (MIT, © Matt Pocock)
- **unslop** — from [pstack](https://github.com/cursor/plugins/tree/main/pstack) by
  [Lauren Tan (poteto)](https://x.com/poteto) (MIT, © Lauren Tan)
- **agent-reach** — from [Agent-Reach](https://github.com/Panniantong/Agent-Reach)
  (MIT, © Agent Eyes)

## References

- Claude Code documentation
