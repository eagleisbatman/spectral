#!/bin/bash
# Spectral — Install for Cursor
# Copies agents as .mdc rule files to .cursor/rules/

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/../agents"
TARGET_DIR=".cursor/rules"

mkdir -p "$TARGET_DIR"

echo "Installing Spectral review prompts to $TARGET_DIR..."

for agent in "$AGENTS_DIR"/*.md; do
  filename=$(basename "$agent" .md)
  cp "$agent" "$TARGET_DIR/spectral-${filename}.mdc"
  echo "  Installed: spectral-${filename}.mdc"
done

echo ""
echo "Done! Spectral prompts are now available as Cursor rules in this project."
echo "Reference them with @spectral-full-spectrum or @spectral-security-audit etc."
