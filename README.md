# Stack

Personal collection of Claude Code skills, tools, loops, and harnesses for customized coding workflows.

## Contents

### Skills (Grill Suite)

Structured interviewing and design planning tools from Matt Pocock's suite:

- **grilling** - Core interview mechanism for stress-testing plans and decisions
- **grill-me** - Interview without working directory
- **grill-with-docs** - Interview in a repo, writes to CONTEXT.md and ADRs
- **domain-modeling** - Building and maintaining domain language glossaries

## Getting Started

These skills are configured to work with Claude Code. To use them:

1. Reference this repo in your Claude Code settings
2. Type `/grill-me`, `/grilling`, or `/grill-with-docs` to invoke
3. Each skill has its own SKILL.md documenting usage and prerequisites

## Organization

```
stack/
├── skills/
│   ├── productivity/
│   │   ├── grilling/
│   │   └── grill-me/
│   └── engineering/
│       ├── grilling/
│       ├── grill-with-docs/
│       └── domain-modeling/
└── .claude/          # Claude Code configuration
```

## Customization

This is a living collection—add, modify, and refine skills to match your personal preferences and coding workflows. Consider adding:

- Custom harnesses for your projects
- Personalized variations of existing skills
- New skills and tools you develop
- Workflow automation loops

## References

- Matt Pocock's [Skills Suite](https://github.com/mattpocock/skills)
- Claude Code documentation
