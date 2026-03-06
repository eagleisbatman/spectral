#!/bin/bash
# Spectral — Install for Cursor
# Copies agents as .mdc rule files to .cursor/rules/
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

# Verify we're in a project root (look for common indicators)
if [ ! -f "package.json" ] && [ ! -f "pyproject.toml" ] && [ ! -f "Cargo.toml" ] && [ ! -f "go.mod" ] && [ ! -f "Gemfile" ] && [ ! -d ".git" ]; then
  echo "Warning: This doesn't look like a project root."
  echo "Cursor rules are project-specific — run this from your project's root directory."
  read -p "Continue anyway? (y/N) " confirm
  [ "$confirm" != "y" ] && [ "$confirm" != "Y" ] && exit 1
fi

TARGET_DIR=".cursor/rules"
mkdir -p "$TARGET_DIR"

echo "Installing Spectral rules to $(pwd)/$TARGET_DIR..."
echo ""

count=0
for agent in "$AGENTS_DIR"/*.md; do
  filename=$(basename "$agent" .md)
  cp "$agent" "$TARGET_DIR/spectral-${filename}.mdc"
  echo "  + spectral-${filename}.mdc"
  count=$((count + 1))
done

echo ""
echo "Installed $count rules."
echo ""
echo "Usage in Cursor:"
echo "  Reference with @spectral-full-spectrum, @spectral-security-audit, etc."

[ -n "$CLEANUP" ] && rm -rf "$CLEANUP"
