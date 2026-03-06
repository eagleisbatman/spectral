# Spectral

**Autonomous code review agents that find issues, fix them, and re-review until clean.**

Spectral is a collection of specialized review agents for AI coding tools. Each agent is a self-contained prompt that turns your AI assistant into an autonomous reviewer — it doesn't just list problems, it fixes them, runs the build, and keeps going until the codebase passes its quality gate.

Works with **Claude Code**, **Cursor**, **Windsurf**, **Codex CLI**, and any AI tool that supports system prompts or custom rules.

---

## Agents

| Agent | Focus | Question It Asks |
|---|---|---|
| **full-spectrum** | Security + Ops + Maintainability | "Is this production-ready?" |
| **security-audit** | Vulnerabilities, auth, injection, data exposure | "How can this be exploited?" |
| **architecture-review** | Coupling, cohesion, boundaries, patterns | "Will this scale and stay maintainable?" |
| **performance-review** | N+1 queries, memory leaks, bundle size, bottlenecks | "What's slow and why?" |
| **code-quality** | Dead code, naming, duplication, test gaps | "Is this clean and correct?" |
| **ux-review** | Loading states, error UX, forms, empty states | "What frustrates the user?" |
| **accessibility-review** | WCAG 2.1 AA, keyboard nav, screen readers, ARIA | "Can everyone use this?" |
| **api-review** | Endpoint consistency, contracts, error responses | "Is this API well-designed?" |
| **data-integrity** | Transactions, race conditions, schema, data loss | "Can data be corrupted or lost?" |

---

## How It Works

Each agent follows the same autonomous loop:

```
Phase 0: Orient    Detect stack, map scope, understand context
Phase 1: Review    Find issues -> Fix them -> Build -> Test -> Repeat (max 3 cycles)
Phase 2: Report    Structured verdict with findings, fixes, and recommendations
```

Agents classify findings by severity (Critical / Warning / Nit), fix everything they can, and produce a clear verdict: **PASS**, **PASS WITH CONDITIONS**, or **FAIL**.

---

## Install

### Claude Code

```bash
git clone https://github.com/eagleisbatman/spectral.git /tmp/spectral
bash /tmp/spectral/install/claude-code.sh
```

Then in Claude Code:
```
> Run the full-spectrum review
> Run a security audit on src/auth/
> Review this project's architecture
```

### Cursor

```bash
# Run from your project root
git clone https://github.com/eagleisbatman/spectral.git /tmp/spectral
bash /tmp/spectral/install/cursor.sh
```

Reference with `@spectral-full-spectrum`, `@spectral-security-audit`, etc.

### Windsurf

```bash
# Run from your project root
git clone https://github.com/eagleisbatman/spectral.git /tmp/spectral
bash /tmp/spectral/install/windsurf.sh
```

### Codex CLI

```bash
# Run from your project root
git clone https://github.com/eagleisbatman/spectral.git /tmp/spectral
bash /tmp/spectral/install/codex.sh
```

Then: `codex "Follow the instructions in .codex/spectral/full-spectrum.md to review this project"`

### Uninstall

```bash
# Removes Spectral from all tools (run from project root for Cursor/Windsurf/Codex)
bash /tmp/spectral/install/uninstall.sh
```

### Manual

Copy any `.md` file from `agents/` into your tool's prompt/rules directory. They're self-contained — no dependencies.

---

## Usage Examples

```
# Full review (security + ops + maintainability)
Run the full-spectrum review

# Focused reviews
Run a security audit
Review the architecture
Check performance of the database layer
Review code quality of src/components/
Run a UX review on the checkout flow
Audit accessibility of the form components
Review the API design
Check data integrity in the payment module
```

---

## Design Principles

- **Fix, don't just report.** Every finding gets a fix unless it requires a major rewrite.
- **Iterative.** Up to 3 review cycles — each cycle narrows scope to files changed by previous fixes.
- **Stack-agnostic.** Auto-detects your tech stack and adapts checks accordingly.
- **Build-verified.** Always runs the build after fixes. Broken builds are not acceptable.
- **Honest verdicts.** PASS / CONDITIONAL / FAIL. No hedging.

---

## Contributing

1. Fork the repo
2. Add or improve an agent in `agents/`
3. Follow the existing structure (Phase 0 / Phase 1 / Phase 2)
4. Submit a PR

Agent ideas welcome — open an issue if you have a review lens you'd like to see.

---

## License

MIT
