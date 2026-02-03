#!/usr/bin/env node

/**
 * Terminal Gallery Statistics Generator
 * Tracks gallery metrics and generates a stats file
 */

const fs = require('fs');
const path = require('path');

const ENTRIES_DIR = path.join(__dirname, 'entries');
const STATS_FILE = path.join(__dirname, 'stats.json');

function generateStats() {
    const entries = [];
    const mdFiles = fs.readdirSync(ENTRIES_DIR).filter(file => file.endsWith('.md'));
    
    mdFiles.forEach(file => {
        const date = file.replace('.md', '');
        const content = fs.readFileSync(path.join(ENTRIES_DIR, file), 'utf8');
        
        // Extract title from markdown
        const titleMatch = content.match(/^#\s+(.+)$/m);
        const title = titleMatch ? titleMatch[1] : 'Unknown';
        
        // Check if image exists
        const imageExists = fs.existsSync(path.join(ENTRIES_DIR, `${date}.png`));
        
        entries.push({
            date,
            title,
            hasImage: imageExists
        });
    });
    
    // Sort by date (newest first)
    entries.sort((a, b) => new Date(b.date) - new Date(a.date));
    
    const stats = {
        totalEntries: entries.length,
        totalImages: entries.filter(e => e.hasImage).length,
        firstEntry: entries[entries.length - 1]?.date || null,
        lastEntry: entries[0]?.date || null,
        entries: entries,
        generatedAt: new Date().toISOString()
    };
    
    fs.writeFileSync(STATS_FILE, JSON.stringify(stats, null, 2));
    
    console.log(`📊 Generated stats: ${stats.totalEntries} entries, ${stats.totalImages} images`);
    console.log(`📅 First entry: ${stats.firstEntry}`);
    console.log(`🆕 Last entry: ${stats.lastEntry}`);
    
    return stats;
}

if (require.main === module) {
    generateStats();
}

module.exports = { generateStats };