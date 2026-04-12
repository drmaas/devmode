# plugin-forge

`plugin-forge` is a repository of installable **Claude Code productivity plugins**.

The top-level README is intentionally short:

- what this repo is for
- what plugins it contains
- how to install them
- how to use each plugin at a high level

Detailed behavior, design, and implementation notes live in each plugin directory.

## What This Repo Contains

This repository ships a Claude plugin marketplace catalog at `.claude-plugin/marketplace.json` and the plugins listed in it.

### Plugins

| Plugin | Path | Purpose |
| --- | --- | --- |
| `devmode` | `devmode/` | Development workflow plugin for switching modes and steering Claude’s execution style. |

## Install Plugins from This Repo

### 1. Add this repository as a marketplace

```text
/plugin marketplace add drmaas/plugin-forge
```

### 2. Install a plugin

```text
/plugin install <plugin-name>@plugin-forge
```

Example:

```text
/plugin install devmode@plugin-forge
```

### 3. Reload plugins in the current session

```text
/reload-plugins
```

You can also browse the marketplace interactively:

1. Run `/plugin`
2. Open **Discover**
3. Choose a plugin from `plugin-forge`
4. Install it in the scope you want

## Use the Plugins

### `devmode`

**Purpose:** choose how Claude should approach work in the current session.

**What it provides:**

- `/devmode:dm` — mode picker and mode status
- `/devmode:builder` — implementation agent used automatically for implementation-oriented modes
- `/devmode:reviewer` — review agent used automatically before final delivery

**How to use it:**

1. Install `devmode`
2. Set a mode:

```text
/devmode:dm
```

or:

```text
/devmode:dm set oneoff
```

3. Give Claude a task

The plugin will inject the active mode and its workflow into the session. In implementation-oriented modes, Claude routes work through the builder/reviewer flow automatically.

**Modes currently included:**

- `og`
- `tdd`
- `vibe`
- `poc`
- `sdd`
- `brainstorm`
- `oneoff`

For full details, see [`devmode/README.md`](./devmode/README.md).

## Adding or Updating Plugins

Each plugin should be self-contained in its own directory and include its own `.claude-plugin/plugin.json`.

When adding a plugin to this repository:

1. Create the plugin directory
2. Add its manifest and files
3. Add it to `.claude-plugin/marketplace.json`
4. Document usage in the plugin's own README

There is no compile step for these plugins. Local development is done by loading a plugin directory directly:

```bash
claude --plugin-dir ./devmode
```

## More Detail

- Marketplace catalog: [`.claude-plugin/marketplace.json`](./.claude-plugin/marketplace.json)
- `devmode` plugin docs: [`devmode/README.md`](./devmode/README.md)
