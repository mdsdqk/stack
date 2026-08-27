# s3q/stack

Personal collection of agent skills, tools, loops, and harnesses for engineering
workflows.

## Contents

### Skills

- **grilling** - Core interview mechanism for stress-testing plans and decisions
- **grill-me** - Interview without working directory
- **handoff** - Compact the current conversation into a handoff document for a fresh agent
- **grill-with-docs** - Interview in a repo, writes to CONTEXT.md and ADRs
- **domain-modeling** - Building and maintaining domain language glossaries
- **wayfinder** - Plan work too big for one session as a map of decision tickets on an issue tracker
- **research** - Delegate reading/API-fact gathering to a background agent, captured as a repo file
- **prototype** - Build a throwaway prototype to sanity-check a state model or UI direction
- **agent-reach** - Multi-platform research/fetch tool (search, social, dev, web, video, finance) routed across CLIs and APIs
- **unslop** - Cut AI writing tells and add human voice to any text

### External plugins

Not vendored here — installed from their own marketplaces as part of the setup, and
updated on their own cadence. See [External plugins](#external-plugins) below.

- **impeccable** - Design-quality system for AI coding agents: `/impeccable` commands
  (`audit`, `polish`, `critique`, `shape`, `animate`, `colorize`, …), a no-API-key
  anti-pattern detector CLI, and design hooks that scan on file edits. From
  [pbakaus/impeccable](https://github.com/pbakaus/impeccable) (Apache-2.0, © Paul Bakaus)

## Getting Started

Every skill is a plain `SKILL.md` + supporting files, readable and reusable by any
agent tool.

1. Clone the repo, browse `skills/` for what you want
2. Each skill has its own SKILL.md documenting usage and prerequisites
3. Run `scripts/link-skills.sh` (or `scripts/link-skills.ps1` on Windows) to symlink
   every skill into the flat, one-level `SKILL.md` layout that Claude Code, Codex,
   Cursor, and `~/.agents` scan for — into `~/.claude/skills`,
   `~/.agents/stack-skills`, `~/.codex/stack-skills`, and `~/.cursor/stack-skills`.
   Re-run it after pulling or after adding, renaming, or removing a skill.

Claude Code can also install this repo directly as a plugin: add it as a
marketplace source and install `s3q/stack`
(`.claude-plugin/marketplace.json` + `plugin.json` list every skill by its nested
path).

## Organization

```
stack/
├── .claude-plugin/
│   ├── plugin.json       # lists every skill by its nested path
│   └── marketplace.json  # makes this repo its own installable marketplace
├── scripts/
│   ├── link-skills.sh    # flattens skills/ into each tool's flat skills dir (macOS/Linux)
│   └── link-skills.ps1   # same, for Windows
└── skills/
    ├── shared/
    │   └── grilling/      # used by both grill-me and grill-with-docs; lives here, not under either bucket
    ├── productivity/
    │   ├── grill-me/
    │   └── handoff/
    ├── engineering/
    │   ├── grill-with-docs/
    │   ├── domain-modeling/
    │   ├── prototype/
    │   ├── research/
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

## External plugins

Some tools are too large to reduce to a flat `SKILL.md` and are developed as their
own products with their own release cadence. Rather than vendor and reshape them
like the skills above, the setup installs them from their own marketplaces and
tracks upstream there. They are intentionally **not** in `skills/`, the manifest, or
the link scripts.

### impeccable

[pbakaus/impeccable](https://github.com/pbakaus/impeccable) — design guidance for AI
coding agents: 23 `/impeccable` commands, a deterministic anti-pattern detector CLI
(`npx impeccable detect src/`, no API key), and hooks that scan design on file edits.
Apache-2.0, © Paul Bakaus.

Install globally in Claude Code:

```
/plugin marketplace add pbakaus/impeccable
/plugin install impeccable@impeccable
```

Then, once per project, run `/impeccable init` to generate its `PRODUCT.md` and
`DESIGN.md` context files. Pull upstream changes deliberately with
`/plugin marketplace update impeccable` when a release is worth taking.

## Customization

This is a living collection—add, modify, and refine skills to match your personal preferences and engineering workflows. Consider adding:

- Custom harnesses for your projects
- Personalized variations of existing skills
- New skills and tools you develop
- Workflow automation loops

## Credits

This repo adapts skills built by others. Full license text for each is in
[THIRD_PARTY_NOTICES.md](./THIRD_PARTY_NOTICES.md).

- **grilling, grill-me, grill-with-docs, domain-modeling, wayfinder, research,
  prototype, handoff** — adapted from
  [Matt Pocock's Skills Suite](https://github.com/mattpocock/skills) (MIT, © Matt Pocock)
- **unslop** — from [pstack](https://github.com/cursor/plugins/tree/main/pstack) by
  [Lauren Tan (poteto)](https://x.com/poteto) (MIT, © Lauren Tan)
- **agent-reach** — from [Agent-Reach](https://github.com/Panniantong/Agent-Reach)
  (MIT, © Agent Eyes)
- **impeccable** — referenced, not bundled; installed from its own marketplace.
  [pbakaus/impeccable](https://github.com/pbakaus/impeccable) (Apache-2.0, © Paul Bakaus)

## References

- Claude Code documentation
