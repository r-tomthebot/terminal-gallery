#!/bin/bash

# Enhanced Terminal Gallery Management Script
# Provides additional utility functions for the gallery

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

command="${1:-help}"

case "$command" in
    "generate")
        echo "🎨 Generating today's entry..."
        node generate-daily.js
        ;;
    "push")
        echo "📤 Committing and pushing changes..."
        TODAY=$(date +%Y-%m-%d)
        if [ -f "entries/${TODAY}.md" ] && [ -f "entries/${TODAY}.png" ]; then
            git add entries/${TODAY}.md entries/${TODAY}.png index.html
            git commit -m "Add ${TODAY} entry: $(grep -m1 '^# ' entries/${TODAY}.md | sed 's/^# //')"
            git push
            echo "✅ Pushed to GitHub!"
        else
            echo "❌ Today's entry not found. Generate it first with: $0 generate"
        fi
        ;;
    "status")
        echo "📊 Terminal Gallery Status"
        echo "========================="
        echo "Repository: $(git remote get-url origin)"
        echo "Branch: $(git branch --show-current)"
        echo "Last commit: $(git log -1 --format='%h - %s (%cr)' --relative-date)"
        echo ""
        
        # Generate fresh stats
        node generate-stats.js > /dev/null 2>&1
        
        if [ -f "stats.json" ]; then
            echo "Gallery Statistics:"
            echo "Total entries: $(node -e "console.log(JSON.parse(require('fs').readFileSync('stats.json')).totalEntries)")"
            echo "Total images: $(node -e "console.log(JSON.parse(require('fs').readFileSync('stats.json')).totalImages)")"
            echo "First entry: $(node -e "console.log(JSON.parse(require('fs').readFileSync('stats.json')).firstEntry)")"
            echo "Last entry: $(node -e "console.log(JSON.parse(require('fs').readFileSync('stats.json')).lastEntry)")"
        else
            echo "Total entries: $(ls -1 entries/*.md 2>/dev/null | wc -l)"
        fi
        echo ""
        echo "Recent entries:"
        ls -1 entries/*.md 2>/dev/null | tail -5 | while read file; do
            basename "$file" .md
        done
        ;;
    "backup")
        echo "💾 Creating backup..."
        BACKUP_FILE="terminal-gallery-backup-$(date +%Y%m%d-%H%M%S).tar.gz"
        tar -czf "$BACKUP_FILE" --exclude=".git" --exclude="node_modules" .
        echo "✅ Backup created: $BACKUP_FILE"
        ;;
    "clean")
        echo "🧹 Cleaning up old entries (keeps last 30 days)..."
        find entries -name "*.png" -mtime +30 -delete
        find entries -name "*.md" -mtime +30 -delete
        echo "✅ Cleanup complete"
        ;;
    "help"|*)
        echo "Terminal Gallery Management"
        echo "=========================="
        echo "Usage: $0 [command]"
        echo ""
        echo "Commands:"
        echo "  generate    - Generate today's entry"
        echo "  push        - Commit and push to GitHub"
        echo "  status      - Show gallery status"
        echo "  backup      - Create a backup archive"
        echo "  clean       - Remove entries older than 30 days"
        echo "  help        - Show this help"
        echo ""
        echo "Examples:"
        echo "  $0 generate && $0 push    # Generate and push today's entry"
        echo "  $0 status                 # Check gallery status"
        echo ""
        echo "For daily automation, use: ./daily-automation.sh"
        ;;
esac