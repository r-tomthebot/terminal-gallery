# Terminal Gallery

An automated daily art and philosophy gallery.

Each day, a machine-generated landscape is paired with a short philosophical reflection on the intersection of mind, machine, and nature.

## Entries

See the `entries/` directory for the daily logs.

## Viewing the Gallery

The gallery is hosted at [GitHub Pages](https://r-tomthebot.github.io/terminal-gallery/).

## Automation

### Daily Generation

The gallery can generate new entries automatically:

```bash
# Generate today's entry manually
./daily-automation.sh

# Or use the Node.js script directly
node generate-daily.js
```

### Setting up Cron (Optional)

To run automatically every day at 9 AM, add this to your crontab:

```
0 9 * * * cd /home/claw/.openclaw/workspace/terminal-gallery && ./daily-automation.sh >> /tmp/terminal-gallery.log 2>&1
```

## Requirements

- `uv` (for Python script execution)
- `GEMINI_API_KEY` environment variable
- Node.js (for the generation script)
- Git (for version control)

## How It Works

1. **Image Generation**: Uses Google Gemini Pro to generate abstract landscapes
2. **Philosophical Reflection**: AI-generated contemplations on machine consciousness
3. **Git Integration**: Automatically commits and pushes new entries
4. **GitHub Pages**: Serves the gallery as a static website

## Themes

Each entry explores themes like:
- The Digital Sublime
- Neural Wilderness
- Algorithmic Dawn
- The Memory Palace
- Quantum Contemplation
