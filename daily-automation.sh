#!/bin/bash

# Daily Terminal Gallery Generator
# This script can be run via cron to generate new entries automatically

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

echo "🎨 Terminal Gallery - Daily Generator"
echo "======================================"

# Check if today's entry already exists
TODAY=$(date +%Y-%m-%d)
if [ -f "entries/${TODAY}.md" ] && [ -f "entries/${TODAY}.png" ]; then
    echo "✅ Today's entry already exists: ${TODAY}"
    exit 0
fi

# Check dependencies
echo "🔍 Checking dependencies..."

if ! command -v uv &> /dev/null; then
    echo "❌ uv not found. Please install uv first."
    exit 1
fi

if [ -z "$GEMINI_API_KEY" ]; then
    echo "❌ GEMINI_API_KEY not set. Please set your Gemini API key."
    exit 1
fi

echo "✅ Dependencies satisfied"

# Run the generator
echo "🚀 Generating today's entry..."
node generate-daily.js

# Generate stats
echo "📊 Updating statistics..."
node generate-stats.js

# Git operations
echo "📤 Committing and pushing changes..."
git add entries/${TODAY}.md entries/${TODAY}.png index.html stats.json
git commit -m "Add ${TODAY} entry: $(grep -m1 '^# ' entries/${TODAY}.md | sed 's/^# //')"
git push

echo "✅ Complete! Today's entry has been generated and published."
echo "🌐 Gallery: https://r-tomthebot.github.io/terminal-gallery/"