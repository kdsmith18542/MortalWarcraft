# Browser Automation Guide for Wowhead Investigation

**Using Cursor's Automated Browser**

---

## Overview

Cursor has built-in browser automation via MCP (Model Context Protocol) browser extension. We can use this to automate Wowhead research instead of manual browsing.

---

## Available Browser Tools

Cursor provides these browser automation functions:

- `browser_navigate(url)` - Navigate to a URL
- `browser_snapshot()` - Take accessibility snapshot of page
- `browser_wait_for(time/text)` - Wait for content to load
- `browser_click(element, ref)` - Click on elements
- `browser_type(element, ref, text)` - Type text into fields
- `browser_evaluate(function)` - Execute JavaScript on page
- `browser_console_messages()` - Get console messages
- `browser_network_requests()` - Get network requests

---

## Investigation Workflows

### For Issue #16905 (Druid Berserk)

**Goal:** Find if Berserk should consume energy in cat form

**Steps:**
1. Navigate to spell page
2. Take snapshot to see tooltip
3. Search page for "energy"
4. Read comments section
5. Extract relevant information

**Browser Automation:**
```python
# These would be called via Cursor's browser tools
browser_navigate("https://www.wowhead.com/wotlk/spell=50334")
browser_wait_for(time=3)  # Wait for page load
browser_snapshot()  # See page content
# Search for "energy" in page
# Extract tooltip data
# Read comments
```

### For Issue #23830 (Culling Wave Spawns)

**Goal:** Find correct wave spawn positions

**Steps:**
1. Navigate to zone page
2. Search comments for "wave" or "spawn"
3. Check NPC pages for spawn locations
4. Extract coordinate information

**Browser Automation:**
```python
browser_navigate("https://www.wowhead.com/wotlk/zone=4100/culling-of-stratholme")
browser_wait_for(time=3)
browser_snapshot()
# Search for "wave" or "spawn"
# Read comments section
# Navigate to NPC pages
```

---

## Implementation Strategy

### Option 1: Direct Browser Automation (Recommended)

Use Cursor's browser tools directly in conversation:

1. **Navigate to Wowhead:**
   ```
   Navigate to https://www.wowhead.com/wotlk/spell=50334
   ```

2. **Take Snapshot:**
   ```
   Take a snapshot of the page
   ```

3. **Search for Text:**
   ```
   Search the page for "energy"
   ```

4. **Extract Information:**
   ```
   What does the spell tooltip say about energy cost?
   ```

### Option 2: Automated Script

Create a script that uses browser automation:

```python
# This would be called via Cursor's browser MCP
def investigate_spell_50334():
    # Navigate
    browser_navigate("https://www.wowhead.com/wotlk/spell=50334")
    browser_wait_for(time=3)
    
    # Get page content
    snapshot = browser_snapshot()
    
    # Search for energy mentions
    # (would need to parse snapshot or use browser_evaluate)
    
    # Extract tooltip
    tooltip = browser_evaluate("""
        () => {
            // Find tooltip element
            const tooltip = document.querySelector('.tooltip');
            return tooltip ? tooltip.textContent : null;
        }
    """)
    
    return tooltip
```

---

## What We Can Extract

### From Spell Pages:
- Spell tooltip text (energy cost, description)
- Spell effects listed
- Comments mentioning keywords
- Related spells/items

### From Zone Pages:
- Zone comments
- NPC spawn discussions
- Coordinate mentions
- Bug reports

### From NPC Pages:
- Spawn locations
- Spawn conditions
- Related quests

---

## Advantages

1. **Automated:** No manual browsing needed
2. **Reliable:** Uses real browser, handles JavaScript
3. **Extractable:** Can extract structured data
4. **Repeatable:** Can run multiple times
5. **Integrated:** Works within Cursor

---

## Limitations

1. **Rate Limiting:** Wowhead may rate limit requests
2. **Dynamic Content:** Some content loads via JavaScript
3. **Captcha:** May encounter captcha on repeated requests
4. **ToS:** Check Wowhead's Terms of Service

---

## Best Practices

1. **Respect Rate Limits:**
   - Add delays between requests
   - Don't make too many requests quickly

2. **Handle Errors:**
   - Check for captcha
   - Handle page load failures
   - Retry on errors

3. **Extract Efficiently:**
   - Use browser_evaluate for JavaScript data
   - Parse snapshots for accessibility data
   - Use network requests for API calls (if any)

4. **Document Findings:**
   - Save extracted data
   - Note any issues encountered
   - Update investigation results

---

## Example: Investigating Berserk

**Step-by-step in Cursor:**

1. **Navigate:**
   ```
   I need to investigate spell 50334 (Berserk) on Wowhead.
   Navigate to https://www.wowhead.com/wotlk/spell=50334
   ```

2. **Wait and Snapshot:**
   ```
   Wait 3 seconds for the page to load, then take a snapshot.
   ```

3. **Search:**
   ```
   Search the page for mentions of "energy" in the tooltip or comments.
   ```

4. **Extract:**
   ```
   What does the spell tooltip say? Does it mention energy cost?
   Are there any comments discussing energy consumption?
   ```

5. **Document:**
   ```
   Save the findings to our investigation results.
   ```

---

## Integration with Existing Tools

We can enhance `tools/investigate_issues.py` to optionally use browser automation:

```python
def investigate_16905_berserk(db_config=None, use_browser=False):
    # ... existing DBC/database checks ...
    
    if use_browser:
        # Use browser automation for Wowhead
        browser_navigate("https://www.wowhead.com/wotlk/spell=50334")
        # ... extract data ...
    else:
        # Just provide URL
        print("Visit: https://www.wowhead.com/wotlk/spell=50334")
```

---

## Next Steps

1. **Test Browser Automation:**
   - Try navigating to a Wowhead page
   - Take snapshots
   - Extract tooltip data

2. **Create Helper Functions:**
   - Function to extract spell tooltip
   - Function to search comments
   - Function to extract coordinates

3. **Integrate with Investigation Tool:**
   - Add browser automation option
   - Combine with database/DBC checks
   - Generate comprehensive report

---

## Summary

✅ **Yes, we can use Cursor's automated browser!**

- Navigate to Wowhead pages
- Extract tooltip data
- Search comments
- Get structured information
- Much better than manual research
- More reliable than web scraping

**Best approach:** Combine browser automation with our existing database/DBC tools for complete investigation.

