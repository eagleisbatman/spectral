# Spectral

**Autonomous code review agents that find issues, fix them, and re-review until clean.**

Spectral is a collection of specialized review agents for AI coding tools. Each agent is a self-contained prompt that turns your AI assistant into an autonomous reviewer — it doesn't just list problems, it fixes them, runs the build, and keeps going until the codebase passes its quality gate.

Works with **Claude Code**, **Cursor**, and **Codex CLI**.

---

## Agents

| Agent | Focus | Question It Asks |
|---|---|---|
| **spectral-suite** | Orchestrator — dispatches specialists based on your stack | "Which reviews does this project need?" |
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

## Methodology: The 3-Lens Approach

Every Spectral agent applies 3 unbiased analytical lenses to its domain:

| Lens | Perspective | Question |
|---|---|---|
| **Lens 1** | Adversarial / Attacker | "How does this break?" |
| **Lens 2** | Ops / SRE | "How does this fail at 3 AM?" |
| **Lens 3** | New Team Member / Maintainer | "How does this confuse?" |

The agent clears its analytical frame between lenses, treating the code fresh each time. This prevents anchoring and ensures comprehensive coverage from fundamentally different perspectives.

---

## How It Works

Each agent follows the same autonomous loop:

```
Phase 0: Orient    Detect stack, map scope, understand context
Phase 1: Review    3 lenses -> Fix everything -> Build -> Test -> Repeat (max 3 cycles)
Phase 2: Report    Structured verdict with findings per lens, fixes, and recommendations
```

Agents classify findings by severity (Critical / Warning / Nit), fix everything they can, and produce a clear verdict: **PASS**, **PASS WITH CONDITIONS**, or **FAIL**.

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

> **Upgrading from v1.x?** Run `spectral install` — it automatically cleans up renamed agents (`full-spectrum` → `triad-review`) and installs the new orchestrator (`spectral-suite`).

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
  + Claude Code: installed (11/11 agents)
  + Cursor: installed (11/11 rules)
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

**Claude Code:**
```
Run a spectral review                  # Launches spectral-suite orchestrator
Run the triad review                   # Single-pass 3-lens review
Run a security audit on src/auth/      # Domain-specific specialist
Review this project's architecture     # Domain-specific specialist
```

**Cursor:** Reference with `@spectral-spectral-suite`, `@spectral-triad-review`, `@spectral-security-audit`, etc.

**Codex CLI:**
```bash
codex "Run a spectral review"
codex "Follow the security-audit instructions to audit this project"
```

---

## Design Principles

- **3 lenses, every agent.** Attacker, Ops, and Maintainer perspectives applied to each domain.
- **Fix, don't just report.** Every finding gets a fix unless it requires a major rewrite.
- **Fix-First Heuristic.** Mechanical fixes are auto-applied; judgment calls are batched for human input. Each agent knows which is which for its domain.
- **Confidence tiers.** Findings tagged HIGH / MEDIUM / LOW. Low-confidence items are never auto-fixed — presented as "Possible: verify manually."
- **No hand-waving.** Agents never say "likely handled" or "probably fine." They verify in code or flag as UNVERIFIED.
- **Suppressions.** Each agent has domain-specific "do not flag" lists to reduce false positives (vendor code, test fixtures, intentional patterns).
- **Iterative.** Up to 3 review cycles — each cycle narrows scope to files changed by previous fixes.
- **Stack-agnostic.** Auto-detects your tech stack and adapts checks accordingly.
- **Build-verified.** Always runs the build after fixes. Broken builds are not acceptable.
- **Honest verdicts.** PASS / CONDITIONAL / FAIL. No hedging.
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
