#!/bin/bash
# Spectral — Uninstall
# Removes Spectral agents/rules from all supported tools.

set -e

echo "Spectral Uninstaller"
echo ""

removed=0

# Claude Code
CLAUDE_DIR="$HOME/.claude/agents"
if ls "$CLAUDE_DIR"/full-spectrum.md "$CLAUDE_DIR"/security-audit.md "$CLAUDE_DIR"/architecture-review.md "$CLAUDE_DIR"/performance-review.md "$CLAUDE_DIR"/code-quality.md "$CLAUDE_DIR"/ux-review.md "$CLAUDE_DIR"/accessibility-review.md "$CLAUDE_DIR"/api-review.md "$CLAUDE_DIR"/data-integrity.md 2>/dev/null 1>&2; then
  echo "Found Spectral agents in $CLAUDE_DIR"
  rm -f "$CLAUDE_DIR"/{full-spectrum,security-audit,architecture-review,performance-review,code-quality,ux-review,accessibility-review,api-review,data-integrity}.md
  echo "  Removed."
  removed=$((removed + 1))
fi

# Cursor (current directory)
if ls .cursor/rules/spectral-*.mdc 2>/dev/null 1>&2; then
  echo "Found Spectral rules in .cursor/rules/"
  rm -f .cursor/rules/spectral-*.mdc
  echo "  Removed."
  removed=$((removed + 1))
fi

# Windsurf (current directory)
if ls .windsurf/rules/spectral-*.md 2>/dev/null 1>&2; then
  echo "Found Spectral rules in .windsurf/rules/"
  rm -f .windsurf/rules/spectral-*.md
  echo "  Removed."
  removed=$((removed + 1))
fi

# Codex (current directory)
if [ -d ".codex/spectral" ]; then
  echo "Found Spectral agents in .codex/spectral/"
  rm -rf .codex/spectral
  echo "  Removed."
  removed=$((removed + 1))
fi

if [ "$removed" -eq 0 ]; then
  echo "No Spectral installations found."
  echo "(For Cursor/Windsurf/Codex, run this from the project root where you installed.)"
else
  echo ""
  echo "Uninstalled from $removed location(s)."
fi
