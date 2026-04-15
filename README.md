# devmode

`devmode` is a standalone workflow tool for major AI coding harnesses.

It gives you:

- a global `devmode` CLI on `PATH`
- a repo installer that drops the needed workspace assets into any repository
- mode-based execution (`og`, `tdd`, `vibe`, `poc`, `sdd`, `brainstorm`, `oneoff`)
- builder/reviewer routing with persistent mode state outside the repo
- a bundled `devmode-ux-designer` skill for frontend, accessibility, and other user-facing work

## Install the CLI

Install it directly:

```bash
curl -fsSL https://raw.githubusercontent.com/drmaas/devmode/refs/heads/main/install.sh | bash
```

That installs a global `devmode` wrapper and a local share directory under `~/.local` by default.

If you already have the repository cloned, `./install.sh` still works.

## Install devmode into a repository

```bash
cd /path/to/repo
devmode install
```

If the target repo does not already have a `CLAUDE.md`, `devmode` creates one as the project instruction file.

If the target repo already has a `CLAUDE.md`, `devmode` leaves it alone and writes `.claude/rules/devmode.md` instead.

## Uninstall

Remove devmode from a repository:

```bash
cd /path/to/repo
devmode uninstall
```

That removes the devmode-managed workspace assets, removes the devmode hook entries from `.claude/settings.json`, and deletes `CLAUDE.md` only when it exactly matches the generated devmode template.

Remove the global CLI install:

```bash
devmode uninstall --global
```

You can also remove the global install directly from this repository:

```bash
./install.sh uninstall
```

Or from the raw installer:

```bash
curl -fsSL https://raw.githubusercontent.com/drmaas/devmode/refs/heads/main/install.sh | bash -s uninstall
```

## Use devmode

Inside an installed repository:

```text
 /devmode
 /devmode status
 /devmode list
 /devmode set oneoff
```

From the shell:

```bash
devmode status
devmode list
devmode set og
devmode explain sdd
devmode install
devmode uninstall
```

Implementation-oriented modes route through `devmode-builder` and `devmode-reviewer`. `brainstorm` stays non-coding.

## What gets installed into the target repo

`devmode install` writes the shared workspace layout used by major coding harnesses:

- `.claude/commands/devmode.md`
- `.claude/skills/devmode-*`
- `.claude/agents/devmode-*.md`
- `.claude/settings.json` hook entries that call the global `devmode` CLI
- `CLAUDE.md` or `.claude/rules/devmode.md`

## Repository layout

This repository is the product source:

- `bin/` - global CLI
- `commands/` - installed project command source
- `skills/` - installed skill source, including bundled optional skills such as `devmode-ux-designer`
- `agents/` - installed subagent source
- `templates/` - generated instruction files for target repos

## Notes

- Mode state is stored outside repositories.
- Installed hooks call the global `devmode` binary, so there is no plugin-root path resolution problem anymore.
- The on-disk layout uses `.claude/` and `CLAUDE.md` because those conventions are widely honored across major coding harnesses.
