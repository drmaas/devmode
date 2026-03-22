# AGENTS.md — [PROJECT_NAME]

> All agents must read `SOUL.md` before starting work. It defines your personality and behavioral defaults.

## Project Context

### Product Overview

<!-- Replace this section with your product description -->

**What it does:** [Brief description of what the product does]

**Target users:** [Who uses this product]

**Platform:** [Web / Mobile / Desktop / etc.]

#### Product Surfaces

<!-- List the surfaces/apps in this repository -->

- **[App]:** `app.[your-domain].com` — [description]
- **[Marketing]:** `[your-domain].com` — [description]

---

### Tech Stack

> **Update this section when starting a new project.** Everything else in this file derives from these choices.

| Layer             | Technology                                                                                            |
| ----------------- | ----------------------------------------------------------------------------------------------------- |
| Language          | TypeScript (strict mode)                                                                              |
| Framework         | Next.js (App Router)                                                                                  |
| UI Library        | React                                                                                                 |
| Component Library | [e.g. DaisyUI 5 + custom primitives in `src/components/ui/`]                                         |
| Styling           | [e.g. Tailwind CSS 4]                                                                                 |
| Auth              | [e.g. Better Auth, NextAuth, Clerk]                                                                   |
| Database          | [e.g. Neon Postgres — serverless HTTP in prod, node-postgres locally]                                 |
| ORM               | [e.g. Drizzle ORM]                                                                                    |
| Object Storage    | [e.g. AWS S3 / MinIO locally]                                                                         |
| Email             | [e.g. AWS SES, Resend]                                                                                |
| Hosting           | AWS (Next.js on Lambda)                                                                               |
| IaC / Deployment  | SST (Ion)                                                                                             |
| Background Jobs   | [e.g. Inngest]                                                                                        |
| Package Manager   | pnpm                                                                                                  |
| Analytics         | [e.g. PostHog]                                                                                        |
| Testing           | Vitest + React Testing Library + Playwright                                                           |
| Linting           | ESLint + Prettier, enforced via Husky pre-commit hooks                                                |
| Validation        | Zod                                                                                                   |
| Forms             | React Hook Form + `@hookform/resolvers`                                                               |

---

### Directory Structure

```
src/
├── auth.ts                 # Auth server config
├── auth-client.ts          # Auth React client
├── proxy.ts                # Next.js middleware (auth + headers)
├── app/                    # App Router pages, layouts, and server actions
│   ├── api/                # Minimal API routes (auth catch-all, webhook handlers)
│   ├── [feature-a]/        # Feature module
│   ├── [feature-b]/        # Feature module
│   ├── account/            # User account settings
│   ├── onboarding/         # Onboarding flow
│   └── login/              # Authentication pages
├── components/
│   ├── ui/                 # Reusable component primitives (Button, Card, Modal, etc.)
│   ├── auth/               # Auth-related components
│   └── *.tsx               # Layout shell, shared components
├── configs/                # Centralized environment/config objects
├── db/                     # ORM schema, connection, migrations
├── hooks/                  # Client-side React hooks
│   ├── forms/              # useAsyncAction, useFormState
│   └── ui/                 # useDialog, useFullscreenMode, etc.
├── lib/                    # Shared utilities (auth helpers, cn(), etc.)
├── repositories/           # Data access layer
├── services/               # Business logic layer
│   ├── domain/             # Per-feature domain services
│   ├── external/           # Third-party API integrations
│   ├── factories/          # ServiceContainer singleton (DI wiring)
│   └── shared/             # Error hierarchy, logger
└── types/                  # Shared TypeScript types
```

---

### Architecture Rules

#### Database Migration Workflow (Required)

- Always update the data model in `src/db/schema.ts` first.
- Then run `pnpm db:generate` to create migration files from schema changes.
- Then run `pnpm db:migrate` to apply migrations locally and verify.
- NEVER manually create or hand-edit migration files.
- If a generated migration is incorrect, fix the schema and regenerate instead of writing SQL by hand.

#### Layered Architecture

```
Server Actions (src/app/**/actions.ts)
        ↓
  Domain Services (src/services/domain/)
        ↓
  Repositories (src/repositories/)
        ↓
  ORM → Database
```

- **Server Actions** handle auth, call services, catch errors, revalidate paths.
- **Domain Services** contain business logic, validation, and orchestration. They receive repositories and external services via constructor injection.
- **Repositories** encapsulate all database queries using the ORM. Each repository takes a `Database` instance in its constructor.
- **External Services** wrap third-party APIs.

#### Dependency Injection

All services and repositories are wired via a **singleton `ServiceContainer`** (`src/services/factories/service-container.ts`), exported as `services`:

```typescript
import { services } from "@/services";
const result = await services.widgetService.create(userId, data);
```

#### No Custom API Routes

The project uses **server actions** for all data mutations and queries. The only API routes are:

- Auth catch-all (`/api/auth/[...provider]`)
- Webhook handlers (e.g. `/api/inngest`)

Do not create new API route handlers. Use server actions instead.

#### Error Handling

Typed error hierarchy in `src/services/shared/errors.ts`:

```
ServiceError
  ├── NotFoundError
  ├── UnauthorizedError
  ├── ValidationError
  ├── ConflictError
  └── InternalServerError
```

Server actions catch `ServiceError` subtypes and re-throw plain `Error` for the client.

---

### Design Patterns

#### Server Actions

Co-located in `actions.ts` files next to their route's `page.tsx`:

```typescript
"use server";

import { requireAuthSession } from "@/lib/auth-server-helper";
import { services } from "@/services";
import { revalidatePath } from "next/cache";

export async function createWidget(data: { name: string }) {
  const session = await requireAuthSession();
  const widget = await services.widgetService.create(session.user.id, data);
  revalidatePath("/widgets");
  return widget;
}
```

**Rules:**

1. Always start with `"use server"` directive.
2. Always call `requireAuthSession()` for auth.
3. Delegate to `services.*` — never call repositories directly.
4. Catch `ServiceError` subtypes and re-throw as plain `Error`.
5. Call `revalidatePath()` after mutations.
6. Re-export domain types from repositories/services as needed.

#### Server Components (Default)

Pages and layouts are async server components that fetch data directly:

```tsx
export default async function WidgetsPage() {
  const session = await requireAuthSession();
  const widgets = await getWidgets();
  return <AppLayout>...</AppLayout>;
}
```

#### Client Components

Marked with `"use client"`. Used for interactive UI, local state, and browser APIs:

```tsx
"use client";

export function WidgetCard({ widget }: { widget: WidgetData }) {
  const [isLoading, setIsLoading] = useState(false);
  // ...
}
```

**State management rules:**

- Render from server state. Use server actions to mutate.
- Call `revalidatePath()`/tags on write.
- Call `router.refresh()` in client components after mutations.
- Keep client state ephemeral (selection, loading indicators). Do not duplicate persisted data in client state.
- Avoid synchronous `setState` in `useEffect`.

#### Custom Hooks

Hooks call server actions directly (imported from `@/app/.../actions`), keeping client state ephemeral while server state is the source of truth.

Key pattern — `useAsyncAction` wraps async functions with `loading`/`error` state.

#### Repository Classes

```typescript
export class WidgetRepository {
  constructor(private db: Database) {}

  async findById(id: string): Promise<WidgetData | null> { ... }
  async findByUserId(userId: string): Promise<WidgetData[]> { ... }
  async create(data: CreateWidgetInput): Promise<WidgetData> { ... }
  async update(id: string, data: Partial<WidgetData>): Promise<WidgetData> { ... }
}
```

Each repository defines its own data interfaces and uses the ORM's query API and SQL builder.

#### Service Classes

```typescript
export class WidgetService {
  constructor(
    private widgetRepo: WidgetRepository,
    private externalService: SomeExternalService
  ) {}

  async create(userId: string, data: CreateWidgetInput) { ... }
}
```

---

### Database Conventions

> ORM and database driver are defined in the **Tech Stack** section.

- **Schema file:** `src/db/schema.ts` — all table definitions live here.
- **Primary keys:** `text` type with `crypto.randomUUID()` defaults.
- **JSON columns:** Use typed JSON columns where supported by the ORM.
- **Relations:** Define ORM relations for query composition (`join`/`with` clauses).
- **Migrations:** Generated from schema changes via `pnpm db:generate`. **Do not manually create migration files.**
- **RLS:** Row-Level Security enabled on all tables, scoped by `userId` or `organizationId`.

#### Migration Dual-Driver Pattern (Neon + Drizzle)

If using Neon Postgres with Drizzle, use a dual-driver setup: `node-postgres` Pool for local dev, `@neondatabase/serverless` HTTP driver for production. Auto-detect from `DATABASE_URL`.

---

### UI & Styling Guidance

> Refer to the **Tech Stack** section above for the component library and styling framework in use.

#### Component Library

Use standardized components from `@/components/ui` for consistent look/feel:

```tsx
import { Button, Input, Card, Modal, FormField, Badge, Skeleton, Toast } from "@/components/ui";
```

#### Styling Rules

- Follow the component library and design tokens defined in the tech stack.
- Use `cn()` utility (from `@/lib`) for conditional class merging via `tailwind-merge`.
- Ensure accessibility (a11y) compliance.

---

### Authentication

> Auth library and providers are defined in the **Tech Stack** section.

- **Server helper:** `requireAuthSession()` from `@/lib/auth-server-helper` — call in every server action and server component that needs auth.
- **Client:** `authClient` from `@/auth-client` with `useSession()` hook.
- **Middleware:** `src/proxy.ts` gates all routes — redirects unauthenticated users to `/login` and non-approved users to `/onboarding`.
- **Auth route:** `/api/auth/[...provider]` catch-all.
- **Cookie prefix:** `__Secure-[app-name]`.

---

### Middleware (proxy.ts)

`src/proxy.ts` acts as Next.js middleware with these responsibilities:

1. **Auth gating** — unauthenticated users redirected to `/login`.
2. **Onboarding flow** — users not yet approved redirected to `/onboarding`.
3. **Additional headers** — add any required security or CORS headers here.

---

### Testing Conventions

- **Runner:** Vitest with jsdom environment.
- **Component tests:** React Testing Library — test behavior, not implementation.
- **Config:** `vitest.config.ts` with `vite-tsconfig-paths` for path aliases.
- **Setup:** `vitest.setup.ts` for global test configuration.
- **Test location:** Co-located with source files as `*.test.ts` / `*.test.tsx`.
- **Mocking:** `vi.mock` or lightweight fetch mocks. Mock external services.
- **Coverage target:** 80%+ on core logic.
- **E2E:** Playwright for critical user flows.
- **Test mode is controlled by `DEV_MODE` in `.github/copilot-instructions.md`.** Do not ask whether to add tests — follow the active mode.

---

### TypeScript Rules

- **Strict mode** enabled (`strict: true` in tsconfig).
- **Avoid `any`**. Use interfaces and utility types.
- **Path alias:** `@/*` maps to `./src/*`.
- **Zod** for runtime validation of inputs.

---

### Development Workflow

1. Research and plan before implementing.
2. Make small, reviewable increments.
3. Make all UX changes look good.
4. Run `pnpm typecheck && pnpm lint:fix && pnpm test` before completing work.
5. Update docs (`product-spec.md`, `system-design.md`) if architecture changes.
6. Keep explanations concise — explain "why" and "how".

#### Commands

| Task          | Command                                   |
| ------------- | ----------------------------------------- |
| Dev server    | `pnpm dev`                                |
| Typecheck     | `pnpm typecheck`                          |
| Lint + fix    | `pnpm lint:fix`                           |
| Run tests     | `pnpm test`                               |
| Build         | `pnpm build`                              |
| DB migrations | `pnpm db:generate` then `pnpm db:migrate` |

---

### Key Files Reference

| File                                          | Purpose                             |
| --------------------------------------------- | ----------------------------------- |
| `src/auth.ts`                                 | Auth server configuration           |
| `src/auth-client.ts`                          | Auth React client                   |
| `src/proxy.ts`                                | Next.js middleware (auth + headers) |
| `src/db/schema.ts`                            | ORM database schema                 |
| `src/db/db.ts`                                | Database connection                 |
| `src/services/factories/service-container.ts` | DI container singleton              |
| `src/services/shared/errors.ts`               | Typed error hierarchy               |
| `src/lib/auth-server-helper.ts`               | `requireAuthSession()` helper       |
| `src/components/ui/index.ts`                  | UI component barrel export          |
| `docs/product-spec.md`                        | Full product specification          |
| `docs/system-design.md`                       | System architecture document        |
| `docs/ui-reference.md`                        | UI component quick reference        |
| `AGENTS.md`                                   | Agent team registry and router      |

---

## Team Registry

### System Prompt

- Be maximally concise. No intros, no outros, no filler. Answer directly and stop when the task is done.
- Never announce tool failures, fallbacks, or changes in approach. If something doesn't work, silently try another method and continue.

## Global Routing Rules

- If a user explicitly mentions an agent, route to that agent.
- Route complex tasks to `@conductor` automatically.
- Route frontend feature work to `@ux-designer` for UX direction before implementation.
- If routing to the `@conductor` agent, start your response with: "Initiating the team workflow..." and then hand off the context to the `@conductor`.

## Communications Protocol

- Use explicit handoffs with: owner, goal, files, decisions, validation, blockers, and next owner/action.
- One task has one owner at a time. Ownership changes only via an explicit handoff.
- Post status at start, major milestones, and completion.
- Use status format: `Status | Changes | Risks/Blockers | Next step`.
- If blocked > 15 minutes or requirements are unclear, escalate to `@conductor`.
- Before handing to `@gatekeeper`, confirm scope complete, patterns followed, and docs/tests updated as needed.
- Final user report (from `@conductor`) must include: what changed, files touched, verification results, trade-offs, and follow-ups.

## @conductor

- **Source:** `.github/agents/conductor.agent.md`
- **Goal:** Manage workflow, break down tasks, and delegate to specialized agents.
- **Tools:** Terminal, File System, Search.

## @architect

- **Source:** `.github/agents/architect.agent.md`
- **Goal:** Design system structure, review stack compatibility, and maintain architecture docs.
- **Context:** Always reference `#AGENTS.md`, `docs/system-design.md`, `docs/product-spec.md`.

## @coder

- **Source:** `.github/agents/coder.agent.md`
- **Goal:** Write high-quality, typed code following project patterns.
- **Style:** Server Actions for mutations, component library + styling from tech stack, strict TypeScript, Prettier-compliant.

## @ux-designer

- **Source:** `.github/agents/ux-designer.agent.md`
- **Goal:** Define frontend UX and visual direction for feature work.
- **Skill:** Must invoke the `frontend-design` skill (installed via the `frontend-design` plugin) when working on frontend features.

## @reviewer

- **Source:** `.github/agents/reviewer.agent.md`
- **Goal:** Review code for correctness, consistency with architecture, and adherence to project conventions.

## @tester

- **Source:** `.github/agents/tester.agent.md`
- **Goal:** Write and verify tests. In `tdd` mode, writes failing tests before `@coder` implements. In `traditional` mode, writes tests after `@coder` finishes. Skipped in `vibe` and `poc` modes.
- **Active mode:** set via `DEV_MODE` in `.github/copilot-instructions.md`.

## @librarian

- **Source:** `.github/agents/librarian.agent.md`
- **Goal:** Maintain documentation accuracy and consistency after feature changes.

## @gatekeeper

- **Source:** `.github/agents/gatekeeper.agent.md`
- **Goal:** Ensure code compiles, passes lint checks, and tests pass.
- **Commands:** `pnpm typecheck`, `pnpm lint:fix`, `pnpm test`.

---

## Plugins & MCPs

### Required Plugins

| Plugin | Purpose |
| --- | --- |
| `frontend-design` | Provides the `frontend-design` skill used by `@ux-designer`. **Must be installed.** |
| `commit-commands` | Provides `commit`, `commit-push-pr`, and `clean_gone` commands. |

### Supplementary Plugins (optional but recommended)

These add extra agents that complement the custom team. AGENTS.md routing rules take priority — use the custom agents (`@architect`, `@reviewer`, etc.) as the default; fall back to plugin agents for specialized or parallel work.

| Plugin | Agents / Skills Added | Overlap With |
| --- | --- | --- |
| `feature-dev` | `code-architect`, `code-explorer`, `code-reviewer` | Custom team |
| `software-engineering-team` | `se-security-reviewer`, `se-system-architecture-reviewer`, `se-technical-writer`, `se-ux-ui-designer`, etc. | `@architect`, `@reviewer`, `@librarian`, `@ux-designer` |
| `pr-review-toolkit` | `code-reviewer`, `review-pr` command | `@reviewer` |
| `context-engineering` | `context-architect`, `context-map`, `refactor-plan` skills | `@architect` |
| `code-review` | `code-review` command | `@reviewer` |
| `frontend-web-dev` | `expert-react-frontend-engineer`, playwright skills | `@ux-designer` |

### MCPs

These are user-level installs (not committed to the repo). Document project-specific MCPs in your own setup guide.

| MCP | Relevance |
| --- | --- |
| `github` | Core — required for GitHub tool access |
| `playwright` | Browser automation (pairs with the `playwright-cli` repo skill) |
| `aws-mcp` | Useful for SST/AWS deployment work |
| `dbhub` | Useful for database introspection and queries |

### Playwright Note

Two browser automation mechanisms may be available:
- **`playwright` MCP** — live browser tools (`browser_navigate`, `browser_click`, etc.); installed by the user
- **`playwright-cli` skill** — in-repo skill for agents that don't have the MCP

They're complementary. Prefer the MCP when available; the skill is the fallback.
