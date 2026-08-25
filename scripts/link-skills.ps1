# Symlinks each skill in this repo into the flat, one-level-deep layout that
# Claude Code, Codex, Cursor, and other agent tools expect when scanning for
# SKILL.md files. Safe to re-run after every `git pull` or after adding a
# new skill to the manifest below.
#
# Always use this script (not `ln -s` in Git Bash) to create these links on
# Windows: Git Bash's `ln -s` has been observed to silently fall back to a
# real recursive copy instead of a symlink, desyncing the flattened copy
# from the source. Creating a symlink may require Developer Mode enabled or
# an elevated (Admin) PowerShell session.

$ErrorActionPreference = "Stop"

$RepoDir = Split-Path -Parent $PSScriptRoot

$Skills = @{
  "agent-reach"               = "capabilities\agent-reach"
  "unslop"                    = "capabilities\unslop"
  "domain-modeling"           = "engineering\domain-modeling"
  "grill-with-docs"           = "engineering\grill-with-docs"
  "prototype"                 = "engineering\prototype"
  "research"                  = "engineering\research"
  "setup-matt-pocock-skills"  = "engineering\setup-matt-pocock-skills"
  "wayfinder"                 = "engineering\wayfinder"
  "grill-me"                  = "productivity\grill-me"
  "grilling"                  = "shared\grilling"
}

$Targets = @(
  (Join-Path $HOME ".claude\skills"),
  (Join-Path $HOME ".agents\stack-skills"),
  (Join-Path $HOME ".codex\stack-skills"),
  (Join-Path $HOME ".cursor\stack-skills")
)

foreach ($target in $Targets) {
  $item = Get-Item -Path $target -Force -ErrorAction SilentlyContinue
  if ($item -and $item.LinkType) {
    Remove-Item -Path $target -Force -Confirm:$false
  }
  if (-not (Test-Path $target)) {
    New-Item -ItemType Directory -Path $target -Force | Out-Null
  }

  foreach ($flatName in $Skills.Keys) {
    $relPath = $Skills[$flatName]
    $linkPath = Join-Path $target $flatName
    $srcPath = Join-Path $RepoDir "skills\$relPath"

    $existing = Get-Item -Path $linkPath -Force -ErrorAction SilentlyContinue
    if ($existing) {
      if ($existing.LinkType) {
        Remove-Item -Path $linkPath -Force -Confirm:$false
      } else {
        Write-Warning "Skipping ${linkPath}: exists and is not a symlink"
        continue
      }
    }

    New-Item -ItemType SymbolicLink -Path $linkPath -Target $srcPath | Out-Null
    Write-Host "linked $linkPath -> $srcPath"
  }
}
