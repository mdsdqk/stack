#!/usr/bin/env bash
# Symlinks each skill in this repo into the flat, one-level-deep layout that
# Claude Code, Codex, Cursor, and other agent tools expect when scanning for
# SKILL.md files. Safe to re-run after every `git pull` or after adding a
# new skill to the manifest below.
#
# On native Windows, use scripts/link-skills.ps1 instead — `ln -s` under
# Git Bash on Windows has been observed to silently fall back to a real
# recursive copy instead of a symlink, desyncing the flattened copy from
# the source.
set -euo pipefail

if [[ "$(uname -s)" == MINGW* || "$(uname -s)" == MSYS* ]]; then
  echo "Detected Git Bash on Windows. Run scripts/link-skills.ps1 instead" >&2
  echo "(ln -s here can silently fall back to a real copy)." >&2
  exit 1
fi

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# flat-name:relative-path-under-skills/
SKILLS=(
  "agent-reach:capabilities/agent-reach"
  "unslop:capabilities/unslop"
  "domain-modeling:engineering/domain-modeling"
  "grill-with-docs:engineering/grill-with-docs"
  "prototype:engineering/prototype"
  "research:engineering/research"
  "setup-matt-pocock-skills:engineering/setup-matt-pocock-skills"
  "wayfinder:engineering/wayfinder"
  "grill-me:productivity/grill-me"
  "grilling:shared/grilling"
)

# target-dir per agent tool that needs a flat, one-level skills folder
TARGETS=(
  "$HOME/.claude/skills"
  "$HOME/.agents/stack-skills"
  "$HOME/.codex/stack-skills"
  "$HOME/.cursor/stack-skills"
)

for target in "${TARGETS[@]}"; do
  # If a previous setup left this as a symlink to the whole skills/ dir,
  # replace it with a real directory we can populate per-skill.
  if [[ -L "$target" ]]; then
    rm "$target"
  fi
  mkdir -p "$target"

  for entry in "${SKILLS[@]}"; do
    flat_name="${entry%%:*}"
    rel_path="${entry##*:}"
    link_path="$target/$flat_name"
    src_path="$REPO_DIR/skills/$rel_path"

    if [[ -L "$link_path" ]]; then
      rm "$link_path"
    elif [[ -e "$link_path" ]]; then
      echo "Skipping $link_path: exists and is not a symlink" >&2
      continue
    fi

    ln -s "$src_path" "$link_path"
    echo "linked $link_path -> $src_path"
  done
done
