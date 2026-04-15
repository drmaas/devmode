# devmode

`devmode` is a standalone Claude Code workflow tool.

It gives you:

- a global `devmode` CLI on `PATH`
- a repo installer that drops the needed `.claude/` assets into any repository
- mode-based execution (`og`, `tdd`, `vibe`, `poc`, `sdd`, `brainstorm`, `oneoff`)
- builder/reviewer routing with persistent mode state outside the repo

## Install the CLI

From a clone of this repository:

```bash
./install.sh
```

That installs a global `devmode` wrapper and a local share directory under `~/.local` by default.

## Install devmode into a repository

```bash
devmode install /path/to/repo
```

If the target repo does not already have a `CLAUDE.md`, `devmode` creates one.

If the target repo already has a `CLAUDE.md`, `devmode` leaves it alone and writes `.claude/rules/devmode.md` instead.

## Uninstall

Remove devmode from a repository:

```bash
devmode uninstall /path/to/repo
```

That removes the devmode-managed `.claude/` assets, removes the devmode hook entries from `.claude/settings.json`, and deletes `CLAUDE.md` only when it exactly matches the generated devmode template.

Remove the global CLI install:

```bash
devmode uninstall --global
```

You can also remove the global install directly from this repository:

```bash
./install.sh uninstall
```

## Use devmode

Inside an installed repository:

```text
/devmode:dm
/devmode:dm status
/devmode:dm list
/devmode:dm set oneoff
```

From the shell:

```bash
devmode status
devmode list
devmode set og
devmode explain sdd
devmode uninstall .
```

Implementation-oriented modes route through `devmode-builder` and `devmode-reviewer`. `brainstorm` stays non-coding.

## What gets installed into the target repo

`devmode install` writes:

- `.claude/commands/devmode/dm.md`
- `.claude/skills/devmode-*`
- `.claude/agents/devmode-*.md`
- `.claude/settings.json` hook entries that call the global `devmode` CLI
- `CLAUDE.md` or `.claude/rules/devmode.md`

## Repository layout

This repository is the product source:

- `bin/` - global CLI and mode helper
- `commands/` - installed project command source
- `skills/` - installed internal skill source
- `agents/` - installed subagent source
- `templates/` - generated instruction files for target repos

## Notes

- Mode state is stored outside repositories.
- Installed hooks call the global `devmode` binary, so there is no plugin-root path resolution problem anymore.
