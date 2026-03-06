#!/bin/bash
# Spectral — Install for OpenAI Codex CLI
# Copies agents as individual instruction files to .codex/ directory.
# Run this from your project root.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/../agents"

if [ ! -d "$AGENTS_DIR" ]; then
  echo "Agents directory not found. Cloning spectral..."
  TMPDIR=$(mktemp -d)
  git clone --depth 1 https://github.com/eagleisbatman/spectral.git "$TMPDIR/spectral" 2>/dev/null
  AGENTS_DIR="$TMPDIR/spectral/agents"
  CLEANUP="$TMPDIR"
fi

if [ ! -f "package.json" ] && [ ! -f "pyproject.toml" ] && [ ! -f "Cargo.toml" ] && [ ! -f "go.mod" ] && [ ! -f "Gemfile" ] && [ ! -d ".git" ]; then
  echo "Warning: This doesn't look like a project root."
  read -p "Continue anyway? (y/N) " confirm
  [ "$confirm" != "y" ] && [ "$confirm" != "Y" ] && exit 1
fi

TARGET_DIR=".codex/spectral"
mkdir -p "$TARGET_DIR"

echo "Installing Spectral agents to $(pwd)/$TARGET_DIR..."
echo ""

count=0
for agent in "$AGENTS_DIR"/*.md; do
  filename=$(basename "$agent")
  cp "$agent" "$TARGET_DIR/$filename"
  echo "  + $filename"
  count=$((count + 1))
done

echo ""
echo "Installed $count agents."
echo ""
echo "Usage with Codex CLI:"
echo "  codex 'Follow the instructions in .codex/spectral/full-spectrum.md to review this project'"
echo "  codex 'Use .codex/spectral/security-audit.md to audit the auth module'"

[ -n "$CLEANUP" ] && rm -rf "$CLEANUP"
