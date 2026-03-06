#!/bin/bash
# Spectral — Install for Claude Code
# Copies all agents to ~/.claude/agents/

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/../agents"
TARGET_DIR="$HOME/.claude/agents"

mkdir -p "$TARGET_DIR"

echo "Installing Spectral agents to $TARGET_DIR..."

for agent in "$AGENTS_DIR"/*.md; do
  filename=$(basename "$agent")
  cp "$agent" "$TARGET_DIR/$filename"
  echo "  Installed: $filename"
done

echo ""
echo "Done! Spectral agents are now available in Claude Code."
echo "Try: 'Run the full-spectrum review' or 'Run a security audit'"
