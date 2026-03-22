# coding-agent-template

A reusable template for SST/Next.js projects with a pre-configured AI agent team, behavioral guide, and tooling setup for GitHub Copilot CLI and VS Code Copilot.

## What's in the box

| File / Directory | Purpose |
| --- | --- |
| `AGENTS.md` | Single source of truth — project context, tech stack, architecture rules, and agent team registry. **Update the Tech Stack section for each project.** |
| `SOUL.md` | Behavioral guide for all agents — tone, personality, and defaults. |
| `.github/copilot-instructions.md` | Quick project notes auto-loaded every session — active `DEV_MODE` setting lives here. |
| `.github/agents/` | Custom agent definitions: `architect`, `coder`, `conductor`, `gatekeeper`, `librarian`, `reviewer`, `ux-designer`, `tester` |
| `.github/skills/` | Per-project skills (e.g. `playwright-cli` for browser automation) |

---

## How it all fits together

Plugins are the distribution unit — each one bundles skills, agents, hooks, MCP configs, and slash commands into a single installable package. When installed, everything merges into `.claude/` and becomes available to the main agent at runtime.

The main agent orchestrates everything: it reads skills for context-aware guidance, delegates subtasks to subagents, fires lifecycle hooks (which can inspect or block actions), and reaches out to MCP servers and local tools to actually execute work.

```mermaid
flowchart TD
  MKTPLACE["🛒 Marketplace<br/>Hosts & distributes plugins"]

  subgraph PLUGIN["Plugin bundle  (installs into .claude/)"]
    direction LR
    SK["Skills<br/>SKILL.md files"]
    AG["Agents<br/>Subagent definitions"]
    HK["Hooks<br/>Lifecycle handlers"]
    MC["MCP configs<br/>.mcp.json"]
    CM["Commands<br/>/slash triggers"]
  end

  subgraph RUNTIME["Runtime"]
    direction TB
    AGENT["Main agent<br/>Orchestrates & reasons"]

    subgraph ACTIVATED["Activated from .claude/"]
      direction LR
      SKR["Skills<br/>auto-invoked by context"]
      AGR["Subagents<br/>parallel subtasks"]
      HKR["Hooks<br/>Pre/PostToolUse, Stop…"]
    end

    subgraph TOOLS["Execution layer"]
      direction LR
      MCP["MCP servers<br/>external tools & APIs"]
      FS["File & shell<br/>read, write, bash"]
      CE["Code env<br/>sandbox"]
    end
  end

  MKTPLACE -->|"claude plugin install"| PLUGIN
  PLUGIN -->|"merges into .claude/"| AGENT

  AGENT -->|"reads context"| SKR
  AGENT -->|"delegates Task()"| AGR
  AGENT -->|"triggers events"| HKR
  HKR -.->|"can block / modify"| AGENT
  AGR -.->|"returns result"| AGENT

  AGENT --> MCP
  AGENT --> FS
  AGENT --> CE

  classDef purple fill:#EEEDFE,stroke:#7F77DD,color:#3C3489
  classDef teal   fill:#E1F5EE,stroke:#1D9E75,color:#085041
  classDef coral  fill:#FAECE7,stroke:#D85A30,color:#712B13
  classDef blue   fill:#E6F1FB,stroke:#378ADD,color:#0C447C
  classDef amber  fill:#FAEEDA,stroke:#BA7517,color:#633806
  classDef green  fill:#EAF3DE,stroke:#639922,color:#27500A
  classDef gray   fill:#F1EFE8,stroke:#888780,color:#444441

  class MKTPLACE amber
  class SK,SKR teal
  class AG,AGR,AGENT purple
  class HK,HKR coral
  class MC,MCP blue
  class CM,CE,FS green
  class PLUGIN,RUNTIME,ACTIVATED,TOOLS gray
```

---

## Quick Start

1. Use this repo as a GitHub template (click **Use this template**)
2. Open `AGENTS.md` and update the **Tech Stack** section for your project
3. Open `.github/copilot-instructions.md` and set your default `DEV_MODE`
4. Follow the setup instructions below for your editor

---

## Setup: GitHub Copilot CLI

### 1. Install Copilot CLI

```bash
npm install -g @github/copilot-cli
# or via gh extension
gh extension install github/gh-copilot
```

Then authenticate:

```bash
copilot login
```

### 2. Add plugin marketplaces

Two marketplaces are included with Copilot CLI by default:

```bash
# Built-in — no setup needed, but shown for reference
# copilot plugin marketplace add awesome-copilot github/awesome-copilot
```

Add these marketplaces (not included by default):

```bash
copilot plugin marketplace add claude-code-plugins anthropics/claude-code
copilot plugin marketplace add anthropic-agent-skills anthropics/skills
```

### 3. Install required plugins

These are needed for the agent team to work correctly:

```bash
# Provides the frontend-design skill used by @ux-designer
copilot plugin install frontend-design@claude-code-plugins

# Provides commit, commit-push-pr, and clean_gone commands
copilot plugin install commit-commands@claude-code-plugins
```

### 4. Install optional plugins

These add supplementary agents and skills. All overlap with the custom team but complement it rather than conflict — routing in `AGENTS.md` keeps things sane.

```bash
# Feature development workflow agents (code-architect, code-explorer, code-reviewer)
copilot plugin install feature-dev@claude-code-plugins

# Code review command
copilot plugin install code-review@claude-code-plugins

# PR review toolkit (review-pr command + specialist agents)
copilot plugin install pr-review-toolkit@claude-code-plugins

# Security guidance (pre-edit hooks that surface security reminders)
copilot plugin install security-guidance@claude-code-plugins

# Claude Agent SDK verifier agents
copilot plugin install agent-sdk-dev@claude-code-plugins

# Frontend web dev skills + React/Angular specialist agent
copilot plugin install frontend-web-dev@awesome-copilot

# Specialist engineering team agents (security, architecture, UX, docs, etc.)
copilot plugin install software-engineering-team@awesome-copilot

# Context mapping and refactor planning skills
copilot plugin install context-engineering@awesome-copilot

# Claude API and SDK documentation skill
copilot plugin install claude-api@anthropic-agent-skills

# Document processing suite (Excel, Word, PDF)
copilot plugin install document-skills@anthropic-agent-skills
```

### 5. Configure MCP servers

MCP servers live in `~/.copilot/mcp-config.json`. Below is a recommended configuration — add only what you need:

```json
{
  "mcpServers": {
    "github": {
      "type": "http",
      "url": "https://api.githubcopilot.com/mcp/",
      "headers": {
        "Authorization": "Bearer YOUR_GITHUB_TOKEN"
      }
    },
    "playwright": {
      "type": "local",
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    },
    "aws-mcp": {
      "type": "stdio",
      "command": "uvx",
      "args": [
        "mcp-proxy-for-aws@latest",
        "https://aws-mcp.us-east-1.api.aws/mcp",
        "--metadata",
        "AWS_REGION=us-east-1"
      ]
    },
    "dbhub": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "@bytebase/dbhub@latest",
        "--transport",
        "stdio",
        "--dsn",
        "YOUR_DATABASE_CONNECTION_STRING"
      ]
    }
  }
}
```

> **Note:** `aws-mcp` requires `uvx` (from [uv](https://docs.astral.sh/uv/)). Install with `curl -LsSf https://astral.sh/uv/install.sh | sh`.

---

## Setup: VS Code Copilot

### Custom agents

The `.github/agents/*.agent.md` files are picked up automatically by VS Code Copilot Chat. No additional setup needed — `@architect`, `@coder`, `@conductor`, etc. are available as soon as you open the project.

### MCP servers

VS Code Copilot Chat uses a workspace-level MCP config at `.vscode/mcp.json`. Create this file (don't commit secrets):

```json
{
  "servers": {
    "playwright": {
      "type": "node",
      "command": "npx",
      "args": ["@playwright/mcp@latest"]
    },
    "aws-mcp": {
      "type": "process",
      "command": "uvx",
      "args": [
        "mcp-proxy-for-aws@latest",
        "https://aws-mcp.us-east-1.api.aws/mcp",
        "--metadata",
        "AWS_REGION=us-east-1"
      ]
    },
    "dbhub": {
      "type": "process",
      "command": "npx",
      "args": [
        "@bytebase/dbhub@latest",
        "--transport",
        "stdio",
        "--dsn",
        "YOUR_DATABASE_CONNECTION_STRING"
      ]
    }
  }
}
```

Add `.vscode/mcp.json` to `.gitignore` if it contains connection strings or tokens, or use VS Code's [input variables](https://code.visualstudio.com/docs/copilot/chat/mcp-servers#_add-mcp-servers-to-vs-code) to keep secrets out of the file.

> **Note:** The `github` MCP server is built into VS Code Copilot and doesn't need to be configured here.

### CLI-specific features (not applicable in VS Code)

The following are Copilot CLI-only and don't apply in VS Code Copilot Chat:

- Plugin skills (e.g. `frontend-design`, `playwright-cli`)
- Plugin slash commands (`/commit`, `/code-review`, `/review-pr`, etc.)
- Plugin hooks (e.g. `security-guidance` pre-edit reminders)

The custom agents and `AGENTS.md`/`SOUL.md` context work in both environments.

---

## Development Modes

The agent team supports four development modes that control the full software development lifecycle — not just testing. Set the active mode in `.github/copilot-instructions.md`:

```markdown
## Active Settings

- **Dev mode:** `traditional`
```

### Modes

| Mode | Purpose | When to use |
| --- | --- | --- |
| `traditional` *(default)* | Balanced workflow: design → implement → test → review. | Most features. Solid coverage without slowing down delivery. |
| `tdd` | Test-first. Tests define the design. Red → Green → Refactor. | Critical business logic, complex algorithms, highly concurrent code. |
| `vibe` | Ship fast, no tests. Code quality still enforced via review + lint. | Personal projects, UI experiments, low-risk features where tests aren't worth the ROI. |
| `poc` | Throwaway spike. Minimal workflow, explicit POC markers, readiness checklist. | Validating an idea or approach before committing to a full implementation. |

### SDLC Flows

**`traditional`:**
```
@architect → @ux-designer* → @coder → @tester → @reviewer → @gatekeeper (full) → @librarian
```

**`tdd`:**
```
@architect → @ux-designer* → @tester (RED) → @coder (GREEN) → @tester (verify) → @coder (refactor) → @reviewer → @gatekeeper (full) → @librarian
```

**`vibe`:**
```
@architect* → @ux-designer* → @coder → @reviewer → @gatekeeper (typecheck + lint) → @librarian*
```

**`poc`:**
```
@coder → @gatekeeper (typecheck + lint)
          ↓
     POC markers added to code
     Production Readiness Checklist left in PLAN.md
```

_\* optional / skip for trivial changes or non-frontend work_

### What `@gatekeeper` runs per mode

| Mode | typecheck | lint | tests |
| --- | --- | --- | --- |
| `traditional` | ✅ | ✅ | ✅ |
| `tdd` | ✅ | ✅ | ✅ |
| `vibe` | ✅ | ✅ | ⏭ skipped |
| `poc` | ✅ | ✅ | ⏭ skipped |

### Overriding per task

You can override the mode for a single task without changing the file — just tell `@conductor` directly:

> "Use TDD for this feature."
> "Vibe on this one, I'm just spiking the UI."
> "This is a POC — don't spend time on tests or review."

---

## Customizing for your project

1. **Update `AGENTS.md` → Tech Stack section** — this is the only section you need to change per project. Everything else (architecture rules, patterns, agent behavior) stays the same.
2. **Update `AGENTS.md` → Product Overview section** — fill in your app name, what it does, and target users.
3. **Set your default dev mode** in `.github/copilot-instructions.md`.
4. Leave `SOUL.md` as-is unless you want different agent personality defaults.
5. Leave `.github/agents/` as-is — agent roles are generic by design.
