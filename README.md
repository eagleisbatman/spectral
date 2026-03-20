# Spectral

**Autonomous agents for the full dev lifecycle — plan, debug, review, and ship.**

Spectral is a collection of specialized agents for AI coding tools. Each agent is a self-contained prompt that turns your AI assistant into an autonomous specialist — whether that's planning a feature, investigating a bug, reviewing code through multiple lenses, or shipping a clean PR.

Works with **Claude Code**, **Cursor**, and **Codex CLI**.

---

## Agents

### Lifecycle Agents

| Agent | Focus | Question It Asks |
|---|---|---|
| **spectral-plan** | Planning and architecture design | "What's the right approach and what could go wrong?" |
| **spectral-investigate** | Root-cause debugging | "Why is this failing and what's the fix?" |
| **spectral-ship** | Pre-ship pipeline and PR creation | "Is this ready to merge?" |

### Orchestrator

| Agent | Focus | Question It Asks |
|---|---|---|
| **spectral-suite** | Routes to lifecycle or review agents based on intent and stack | "What does this project need right now?" |

### Review Agents

| Agent | Focus | Question It Asks |
|---|---|---|
| **triad-review** | Security + Ops + Maintainability in a single pass | "Is this production-ready?" |
| **security-audit** | Vulnerabilities, auth, injection, data exposure | "How can this be exploited?" |
| **architecture-review** | Coupling, cohesion, boundaries, patterns | "Will this scale and stay maintainable?" |
| **performance-review** | N+1 queries, memory leaks, bundle size, bottlenecks | "What's slow and why?" |
| **code-quality** | Dead code, naming, duplication, test gaps | "Is this clean and correct?" |
| **ux-review** | Loading states, error UX, forms, empty states | "What frustrates the user?" |
| **accessibility-review** | WCAG 2.1 AA, keyboard nav, screen readers, ARIA | "Can everyone use this?" |
| **api-review** | Endpoint consistency, contracts, error responses | "Is this API well-designed?" |
| **data-integrity** | Transactions, race conditions, schema, data loss | "Can data be corrupted or lost?" |
| **database-review** | Schema design, SQL queries, indexes, migrations, ORM usage | "Is the database layer correct and fast?" |

---

## How It Works

Spectral has two kinds of agents: **lifecycle agents** that help you plan, debug, and ship, and **review agents** that audit your code autonomously.

### Lifecycle Agents

Lifecycle agents cover the phases of development that happen before and after code review:

| Agent | Phase | Modifies Code? | What It Produces |
|---|---|---|---|
| **spectral-plan** | Before coding | No | Implementation plan with approach evaluation |
| **spectral-investigate** | During development | Yes (fixes bugs) | Root-cause analysis with verified fix |
| **spectral-ship** | After coding | Yes (cleans diff, creates PR) | Ship-readiness report + PR |

**spectral-plan** asks forcing questions to surface hidden assumptions, generates 2-3 candidate approaches, evaluates each through Feasibility / Risk / Maintainability lenses, and outputs a concrete step-by-step implementation plan. It never writes code — it produces plans that you (or other agents) execute.

**spectral-investigate** collects symptoms, maps the affected code path, generates ranked hypotheses, and tests them systematically through Code Path / State & Environment / Change History lenses. When the root cause is confirmed with high confidence, it applies the minimal fix and verifies it with the build and tests.

**spectral-ship** runs build/test/lint gates, reviews the diff through Quality Gate / Diff Integrity / Release Hygiene lenses, removes debug artifacts (`console.log`, `debugger`, `binding.pry`, etc.), and creates a PR with a structured body. It's the last line of defense before code reaches reviewers.

### Review Agents

Review agents audit code through domain-specific lenses. Every review agent follows the same autonomous loop:

```
Phase 0: Orient    Detect stack, map scope, understand context
Phase 1: Review    3 lenses -> Fix everything -> Build -> Test -> Repeat (max 3 cycles)
Phase 2: Report    Structured verdict with findings per lens, fixes, and recommendations
```

Agents classify findings by severity (Critical / Warning / Nit), fix everything they can, and produce a clear verdict: **PASS**, **PASS WITH CONDITIONS**, or **FAIL**.

### The 3-Lens Approach

Every agent applies 3 analytical lenses adapted to its domain. Review agents use:

| Lens | Perspective | Question |
|---|---|---|
| **Lens 1** | Adversarial / Attacker | "How does this break?" |
| **Lens 2** | Ops / SRE | "How does this fail at 3 AM?" |
| **Lens 3** | New Team Member / Maintainer | "How does this confuse?" |

Lifecycle agents adapt the 3-lens pattern to their domain (e.g., spectral-plan uses Feasibility / Risk / Maintainability). The agent clears its analytical frame between lenses, treating the subject fresh each time to prevent anchoring.

### The Full Workflow

The agents are designed to work together across the development lifecycle:

```
spectral-plan          → Decide what to build and how
  ↓
  [you write the code]
  ↓
spectral-investigate   → Debug issues that come up during development
  ↓
spectral-suite         → Run the right review agents for your stack
  or triad-review      → Quick single-pass review across 3 lenses
  or specialist agents → Deep review in a specific domain
  ↓
spectral-ship          → Verify ship-readiness, clean up, create PR
```

You don't have to use all of them — each agent is self-contained. Use whichever fits where you are in the development cycle.

### Orchestrator: spectral-suite

**spectral-suite** detects your intent and routes accordingly:

- Planning request → suggests `spectral-plan`
- Debugging request → suggests `spectral-investigate`
- Shipping request → suggests `spectral-ship`
- Review request → detects your tech stack and selects the right review specialists

---

## Install

```bash
git clone https://github.com/eagleisbatman/spectral.git
cd spectral
./spectral install
```

The CLI auto-detects which tools you have and installs agents in the correct format for each:

| Tool | What gets installed | How |
|---|---|---|
| **Claude Code** | `~/.claude/agents/*.md` | Native agent files with YAML frontmatter |
| **Cursor** | `.cursor/rules/spectral-*.mdc` | `.mdc` rules with Cursor frontmatter (`description`, `alwaysApply: false`) |
| **Codex CLI** | `AGENTS.md` | Appends agent instructions — [Codex auto-discovers this file](https://developers.openai.com/codex/guides/agents-md/) |

It also updates instruction files (`~/.claude/CLAUDE.md`, `.cursorrules`, `AGENTS.md`) so the AI knows the agents exist and includes routing hints for selecting the right agent.

> **Upgrading?** Run `spectral install` — it automatically cleans up renamed agents from previous versions and installs all new agents. v2.1 adds 3 lifecycle agents (plan, investigate, ship) alongside the existing 11 review agents.

> **Linux users:** If your tool isn't auto-detected (e.g. Flatpak/AppImage), specify it explicitly: `./spectral install cursor`

### Install for specific tools

```bash
./spectral install claude-code         # Just Claude Code
./spectral install cursor codex        # Multiple tools
```

### Check status

```bash
./spectral status
```

```
  + Claude Code: installed (14/14 agents)
  + Cursor: installed (14/14 rules)
  > Codex: detected, not installed
```

### Update

```bash
git pull
./spectral install
```

Re-running `install` updates both agent files and instruction blocks.

### Other commands

```bash
./spectral list                        # Show all available agents
./spectral uninstall                   # Remove from all tools
./spectral uninstall cursor            # Remove from specific tool
./spectral help                        # Full usage
```

### Manual

Copy any `.md` file from `agents/` into your tool's prompt/rules directory. They're self-contained — no dependencies.

---

## Usage Examples

### Claude Code

Lifecycle agents are triggered by natural language — just describe what you need:

```
# Planning
Help me plan this feature
What's the right architecture for the payments module?
Scope this refactor before I start

# Debugging
Debug this failing test
Why is this returning null?
Find the root cause of this race condition

# Shipping
Ship this
Is this ready to merge?
Create a PR for this work

# Reviews
Run a spectral review                  # Orchestrator selects specialists
Run the triad review                   # Single-pass 3-lens review
Run a security audit on src/auth/      # Domain-specific specialist
Review this project's architecture     # Domain-specific specialist
```

### Cursor

Reference agents with `@spectral-` prefix:
```
@spectral-spectral-plan Help me plan the new auth flow
@spectral-spectral-investigate Why is this test flaky?
@spectral-spectral-ship Create a PR for this branch
@spectral-spectral-suite Review everything
@spectral-security-audit Check src/auth/ for vulnerabilities
```

### Codex CLI

```bash
codex "Help me plan the caching layer"
codex "Debug this failing migration"
codex "Run a spectral review"
codex "Ship this — create a PR"
```

---

## Design Principles

- **3 lenses, every agent.** Each agent applies 3 analytical lenses adapted to its domain — review agents use Attacker/Ops/Maintainer, lifecycle agents use domain-specific equivalents (Feasibility/Risk/Maintainability, Code Path/State/Change History, etc.).
- **Fix, don't just report.** Review and debugging agents fix everything they can. Planning agents produce actionable plans, not vague suggestions.
- **Fix-First Heuristic.** Mechanical fixes are auto-applied; judgment calls are batched for human input. Each agent knows which is which for its domain.
- **Confidence tiers.** Findings tagged HIGH / MEDIUM / LOW. Low-confidence items are never auto-fixed — presented as "Possible: verify manually."
- **No hand-waving.** Agents never say "likely handled" or "probably fine." They verify in code or flag as UNVERIFIED.
- **Suppressions.** Each agent has domain-specific "do not flag" lists to reduce false positives (vendor code, test fixtures, intentional patterns).
- **Iterative.** Review agents run up to 3 cycles — each cycle narrows scope to files changed by previous fixes.
- **Stack-agnostic.** Auto-detects your tech stack and adapts checks accordingly.
- **Build-verified.** Always runs the build after fixes. Broken builds are not acceptable.
- **Honest verdicts.** PASS / CONDITIONAL / FAIL. No hedging.
- **Self-contained.** Every agent is a single markdown file. No dependencies, no runtime, no config. Copy it anywhere and it works.
- **Complete when cheap.** When marginal cost of completeness is near-zero, choose the complete approach.

---

## Contributing

1. Fork the repo
2. Add or improve an agent in `agents/`
3. Follow the existing structure (Phase 0 / Phase 1 with 3 lenses / Phase 2)
4. Submit a PR

Agent ideas welcome — open an issue if you have a review lens you'd like to see.

---

## License

MIT
