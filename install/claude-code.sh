#!/bin/bash
# Spectral — Install for Claude Code
# Copies all agents to ~/.claude/agents/

set -e

TARGET_DIR="$HOME/.claude/agents"

# Resolve agents directory — works both when cloned locally and when script is on disk
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/../agents"

if [ ! -d "$AGENTS_DIR" ]; then
  echo "Agents directory not found. Cloning spectral..."
  TMPDIR=$(mktemp -d)
  git clone --depth 1 https://github.com/eagleisbatman/spectral.git "$TMPDIR/spectral" 2>/dev/null
  AGENTS_DIR="$TMPDIR/spectral/agents"
  CLEANUP="$TMPDIR"
fi

mkdir -p "$TARGET_DIR"

echo "Installing Spectral agents to $TARGET_DIR..."
echo ""

count=0
for agent in "$AGENTS_DIR"/*.md; do
  filename=$(basename "$agent")
  cp "$agent" "$TARGET_DIR/$filename"
  echo "  + $filename"
  count=$((count + 1))
done

echo ""
echo "Installed $count agents to $TARGET_DIR"
echo ""
echo "Usage in Claude Code:"
echo "  > Run the full-spectrum review"
echo "  > Run a security audit on src/auth/"
echo "  > Review this project's architecture"

# Cleanup temp clone if used
[ -n "$CLEANUP" ] && rm -rf "$CLEANUP"
