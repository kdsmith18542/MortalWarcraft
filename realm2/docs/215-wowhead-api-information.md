# Wowhead/WoWDB API Information

**Date:** 2025-01-23

---

## Official API Status

### ❌ **No Official Public API**

Neither **Wowhead** nor **WoWDB** offer official public APIs for programmatic data access.

---

## Available Alternatives

### 1. Blizzard Official API

**URL:** https://dev.battle.net/  
**GitHub:** https://github.com/Blizzard/api-wow-docs

**Limitations:**
- Only covers **live/current** game data
- **Does NOT** have WotLK 3.3.5a historical data
- Requires API key registration
- Rate limited

**Not Useful For:**
- Investigating WotLK 3.3.5a issues
- Historical spell/item data

---

### 2. Wowhead Tooltip System

**What It Is:**
- JavaScript-based tooltips
- Can be embedded in websites
- Provides some data via tooltip system

**How It Works:**
- Wowhead pages load tooltip data via JavaScript
- Data is embedded in page HTML/JSON
- Can be scraped from page source

**Unofficial Endpoints:**
- Tooltip data may be available via JavaScript calls
- Not officially documented
- May change without notice

---

### 3. Web Scraping

**Legal Considerations:**
- Check Wowhead's Terms of Service
- Respect robots.txt
- Don't overload servers
- Use reasonable rate limits

**Methods:**
1. **HTML Parsing:**
   - Download page HTML
   - Parse with BeautifulSoup (Python)
   - Extract tooltip data

2. **JavaScript Execution:**
   - Use Selenium/Playwright
   - Execute page JavaScript
   - Extract tooltip JSON

3. **Network Monitoring:**
   - Monitor browser network requests
   - Find tooltip API endpoints
   - Call endpoints directly (if stable)

---

## Practical Approach for Our Investigation

### Option 1: Manual Research (Recommended)
- Visit Wowhead pages directly
- Read tooltips and comments
- Take notes/screenshots
- Most reliable method

### Option 2: Simple Web Scraping
- Download page HTML
- Parse tooltip data
- Extract spell/item information
- Use with caution and respect

### Option 3: Browser Automation
- Use Selenium to load pages
- Extract tooltip data
- More complex but automated

---

## Implementation for Our Tool

We can add web scraping capabilities to `tools/investigate_issues.py`:

```python
import requests
from bs4 import BeautifulSoup

def fetch_wowhead_spell_data(spell_id):
    """Fetch spell data from Wowhead page."""
    url = f"https://www.wowhead.com/wotlk/spell={spell_id}"
    
    try:
        response = requests.get(url, headers={'User-Agent': 'Mozilla/5.0'})
        soup = BeautifulSoup(response.content, 'html.parser')
        
        # Look for tooltip data in page
        # (Wowhead embeds tooltip data in script tags or data attributes)
        
        # Extract spell name, description, etc.
        # This is fragile and may break if Wowhead changes their HTML
        
        return {
            'url': url,
            'name': extract_name(soup),
            'description': extract_description(soup),
            'comments': extract_comments(soup)
        }
    except Exception as e:
        print(f"Error fetching Wowhead data: {e}")
        return None
```

**Note:** This requires:
- `requests` library
- `beautifulsoup4` library
- Understanding Wowhead's HTML structure
- Handling rate limits

---

## Recommendation

**For Our Investigation:**

1. **Use Manual Research** (most reliable):
   - Visit Wowhead pages
   - Read tooltips and comments
   - Document findings

2. **Use Our SQL/DBC Tools** (automated):
   - Database queries
   - DBC file reading
   - These are reliable and fast

3. **Add Simple Scraping** (optional):
   - Only if needed
   - Use with caution
   - Respect ToS and rate limits

---

## Summary

- ❌ **No official API** from Wowhead/WoWDB
- ✅ **Blizzard API exists** but doesn't cover WotLK 3.3.5a
- ✅ **Web scraping possible** but fragile
- ✅ **Manual research** is most reliable
- ✅ **Our SQL/DBC tools** are best for automated investigation

**Best Approach:** Combine manual Wowhead research with automated database/DBC queries.

