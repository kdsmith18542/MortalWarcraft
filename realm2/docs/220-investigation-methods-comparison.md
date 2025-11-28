# Investigation Methods Comparison

**Date:** 2025-01-23

---

## Three Methods for Investigation

### 1. GitHub API (Fastest for Issues) ⚡⚡⚡

**Tool:** `tools/fetch_github_issue.py`

**Best For:**
- Reading GitHub issue descriptions
- Fetching comments
- Searching issues by keywords
- Getting structured JSON data

**Speed:** ⚡⚡⚡ Very Fast (API call, instant response)

**Example:**
```bash
python3 tools/fetch_github_issue.py --issue 16905 --comments
```

**Advantages:**
- ✅ Fastest method
- ✅ Structured data (JSON)
- ✅ Can fetch all comments
- ✅ Can search issues
- ✅ No browser needed

**Limitations:**
- ❌ Rate limits (60 requests/hour without token)
- ❌ Only works for GitHub

---

### 2. Browser Automation (Best for Wowhead) 🌐

**Tool:** Cursor's automated browser

**Best For:**
- Wowhead pages (no API available)
- Extracting tooltip data
- Searching comments on websites
- Dynamic content that loads via JavaScript

**Speed:** ⚡⚡ Fast (page load + extraction)

**Example:**
```
Navigate to https://www.wowhead.com/wotlk/spell=50334
Take a snapshot
Extract tooltip data
```

**Advantages:**
- ✅ Works for any website
- ✅ Handles JavaScript
- ✅ Can interact with pages
- ✅ Extracts real-time data

**Limitations:**
- ❌ Slower than API
- ❌ May hit rate limits
- ❌ Can break if site changes

---

### 3. Database/DBC Queries (Server Data) 💾

**Tool:** SQL queries, DBC file reading

**Best For:**
- Server-side data (spell_template, creature, etc.)
- Client data (DBC files)
- Current server state
- Fast lookups

**Speed:** ⚡⚡⚡ Very Fast (direct database access)

**Example:**
```bash
mysql -h127.0.0.1 -uroot -p realm2_world < tools/check_spell_50334.sql
```

**Advantages:**
- ✅ Fastest for server data
- ✅ Shows current state
- ✅ Reliable
- ✅ Can query anything

**Limitations:**
- ❌ Only shows our server's data
- ❌ Doesn't show retail behavior
- ❌ Need database access

---

## Recommended Workflow

### For Issue Investigation:

1. **GitHub API** (First - fastest):
   ```bash
   python3 tools/fetch_github_issue.py --issue 16905 --comments
   ```
   - Get issue description
   - Read comments
   - Understand the bug

2. **Database/DBC** (Second - verify current state):
   ```bash
   mysql realm2_world < tools/check_spell_50334.sql
   python3 tools/investigate_issues.py --issue 16905
   ```
   - Check current implementation
   - Compare with issue description

3. **Browser Automation** (Third - retail reference):
   ```
   Navigate to Wowhead
   Extract tooltip data
   Search comments
   ```
   - Verify retail behavior
   - Get community knowledge

4. **Combine Findings:**
   - GitHub: What the bug is
   - Database: What we have
   - Wowhead: What retail has
   - Implement fix based on all three

---

## Speed Comparison

| Method | Time | Use Case |
|--------|------|----------|
| GitHub API | < 1 second | Issue descriptions, comments |
| Database Query | < 1 second | Server data, current state |
| Browser Automation | 3-5 seconds | Wowhead, dynamic content |
| Manual Research | 30+ seconds | When automation fails |

---

## Best Practices

1. **Always start with GitHub API** for issues
2. **Use Database/DBC** to check current state
3. **Use Browser** for Wowhead/retail reference
4. **Combine all three** for complete picture

---

## Tools Summary

| Tool | Method | Speed | Best For |
|------|--------|-------|----------|
| `fetch_github_issue.py` | GitHub API | ⚡⚡⚡ | Issue research |
| `investigate_issues.py` | Database/DBC | ⚡⚡⚡ | Server data |
| Browser Automation | Cursor MCP | ⚡⚡ | Wowhead pages |
| SQL Files | Direct queries | ⚡⚡⚡ | Quick lookups |

---

## Summary

✅ **GitHub API is fastest for issue research!**
✅ **Browser automation works great for Wowhead!**
✅ **Database/DBC for server data!**

**Use the right tool for the job!**

