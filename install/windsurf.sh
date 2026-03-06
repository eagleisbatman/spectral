#!/bin/bash
# Spectral — Install for Windsurf
# Copies agents to .windsurf/rules/ as rule files

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/../agents"
TARGET_DIR=".windsurf/rules"

mkdir -p "$TARGET_DIR"

echo "Installing Spectral review prompts to $TARGET_DIR..."

for agent in "$AGENTS_DIR"/*.md; do
  filename=$(basename "$agent" .md)
  cp "$agent" "$TARGET_DIR/spectral-${filename}.md"
  echo "  Installed: spectral-${filename}.md"
done

echo ""
echo "Done! Spectral prompts are now available as Windsurf rules in this project."
