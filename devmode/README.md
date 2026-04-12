# devmode

`devmode` is a Claude Code plugin for switching the **development flow** Claude should follow in the current session.

## Problem Statement

Claude Code users often want to change **how** Claude works — for example:

- tests-first vs direct implementation
- rapid iteration vs stricter process
- ideation-only vs implementation

The problem is that changing workflow usually means overhauling prompts, editing repo docs, or maintaining custom local setup.

`devmode` solves that by letting the user **toggle their dev flow quickly** without reworking the rest of their development environment. The plugin stores the active mode outside the repo, injects the selected workflow into the session, and keeps the user-facing control surface simple.

## Design

`devmode` is built around four ideas:

1. **Fast mode switching**
   - `/devmode:dm` provides a quick mode picker or direct `set/status/list` commands.

2. **No repo mutation**
   - The active mode is stored in `${CLAUDE_PLUGIN_DATA}/mode.json`, not in tracked project files.

3. **Workflow injection**
   - On session start, the plugin injects the active mode and the behavior Claude should follow for that mode.

4. **Mode-aware execution**
   - In implementation-oriented modes, Claude routes work through the builder/reviewer workflow.
   - In ideation-oriented modes such as `brainstorm`, Claude stays out of code-writing mode.

### Main Components

| Component | Purpose |
| --- | --- |
| `skills/dm/` | Mode picker and mode management command |
| `agents/builder.md` | Implementation workflow agent |
| `agents/reviewer.md` | Review workflow agent |
| `scripts/inject-mode.sh` | Injects selected mode and instructions into the session |
| `scripts/ensure-mode.sh` | Reminds the user to choose a mode if none is set |
| `bin/dm` | Lightweight CLI helper for reading/writing mode state |

## Installation

### From the `plugin-forge` marketplace

```text
/plugin marketplace add drmaas/plugin-forge
/plugin install devmode@plugin-forge
/reload-plugins
```

### From a local directory

```bash
claude --plugin-dir ./devmode
```

## Usage

### 1. Choose a mode

Use the picker:

```text
/devmode:dm
```

Or set one directly:

```text
/devmode:dm set oneoff
/devmode:dm set tdd
/devmode:dm set brainstorm
```

Check the current mode:

```text
/devmode:dm status
```

List all modes:

```text
/devmode:dm list
```

### 2. Give Claude a task

After a mode is set, just work normally. The plugin injects the selected flow into the session.

### 3. Let the mode shape behavior

| Mode | Behavior |
| --- | --- |
| `og` | implement, then verify, then review |
| `tdd` | write tests first, implement to green, then review |
| `vibe` | optimize for fast iteration with lighter process |
| `poc` | explore quickly without claiming production readiness |
| `sdd` | follow requirements → spec → plan → implementation → review |
| `brainstorm` | explore ideas and tradeoffs without writing code |
| `oneoff` | directly implement the user’s request with minimal ceremony |

### Builder and reviewer behavior

For implementation-oriented modes, Claude uses:

- `/devmode:builder` for implementation
- `/devmode:reviewer` for review

These are part of the workflow; users generally do **not** invoke them directly.

### CLI helper

The plugin also exposes a `dm` helper in Bash-enabled contexts:

```bash
dm status
dm list
dm set sdd
dm --json status
```

## Notes

- `brainstorm` is explicitly non-coding mode.
- `oneoff` is explicitly low-ceremony execution mode.
- Detailed implementation notes and future changes should stay with the plugin source rather than the top-level repo README.
