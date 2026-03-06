#!/bin/bash
# Spectral — Install for OpenAI Codex CLI
# Appends agent prompts to AGENTS.md in the project root

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
AGENTS_DIR="$SCRIPT_DIR/../agents"
TARGET_FILE="AGENTS.md"

echo "Installing Spectral review prompts to $TARGET_FILE..."

echo "# Spectral Review Agents" > "$TARGET_FILE"
echo "" >> "$TARGET_FILE"
echo "Use these prompts to run focused code reviews. Copy the relevant section into your prompt." >> "$TARGET_FILE"
echo "" >> "$TARGET_FILE"

for agent in "$AGENTS_DIR"/*.md; do
  filename=$(basename "$agent" .md)
  echo "---" >> "$TARGET_FILE"
  echo "" >> "$TARGET_FILE"
  cat "$agent" >> "$TARGET_FILE"
  echo "" >> "$TARGET_FILE"
  echo "  Added: $filename"
done

echo ""
echo "Done! Review prompts are in $TARGET_FILE."
echo "Use with: codex 'Follow the full-spectrum agent instructions in AGENTS.md to review this project'"
