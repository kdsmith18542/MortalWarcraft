# Mortal Atlas — Web Portal Wiki Module
### File: 49-webportal-wiki-spec.md  
### Version: 1.0  
### Scope: In-Portal Game Wiki / Knowledge Base

---

## 1. Purpose

Add a **Game Wiki / Knowledge Base** to the Mortal Atlas web portal so that:

- Players have a **central, searchable reference** for:
  - Game mechanics (Dynamic Level, Notoriety, Full Loot rules, Shrines, Rifts, etc.).
  - World information (zones, invasions, strongholds, factions, guilds).
  - Items, runes, anomalies, events, and systems.
- Staff and trusted contributors can **maintain documentation** without touching code.
- Certain pages can be **“in-world gated”** (only visible if the character has discovered/unlocked that information in-game, e.g., via Codex flags).

This sits alongside existing Atlas features (Killboard, Map, Market, Profiles, Shop) and reuses the same stack:

- Backend: **Go + Gin + MySQL**
- Frontend: **React + TypeScript + Vite + Tailwind**
- Auth: Existing JWT + roles from the Atlas spec

---

## Related Specs

For full context on the wiki system, see:

- **`24-webportal-mortal-atlas.md`** — Atlas web portal that hosts the wiki
- **`89-mortal-wiki-structure.md`** — Wiki structure and content plan
- **`15-ui-client.md`** — UI system that can access wiki content in-game
- **`38-social-and-onboarding-systems.md`** — Onboarding systems that use wiki content
- **`00-overview.md`** — Overview document that wiki pages reference

---

## 2. High-Level Design

### 2.1 Core Ideas

- **Markdown-based wiki pages** with:
  - Title, slug, content, tags, category, optional icon.
  - Version history and rollback.
- **Role-based editing**:
  - Readers (everyone)
  - Contributors (trusted players)
  - Moderators (can approve/revert)
  - Admins (full control)
- **Integration with game state**:
  - Optional “requires Codex flag(s)” per page.
  - Optional “requires zone discovered / event participated in”.
- **SEO- and UX-friendly**:
  - Clean URLs: `/wiki`, `/wiki/:slug`, `/wiki/tags/:tag`, `/wiki/search`.

---

## 3. Data Model (MySQL)

### 3.1 `wiki_pages`

Stores the current live version of each page.

```sql
CREATE TABLE IF NOT EXISTS wiki_pages (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  slug              VARCHAR(128) NOT NULL UNIQUE,
  title             VARCHAR(256) NOT NULL,
  summary           VARCHAR(512) NULL,
  content_markdown  MEDIUMTEXT NOT NULL,
  category          VARCHAR(64) NOT NULL DEFAULT 'general', -- 'mechanics','lore','locations','builds','dev'
  tags              VARCHAR(512) NULL, -- comma-separated or JSON if preferred
  icon              VARCHAR(128) NULL, -- optional icon key/name
  is_published      TINYINT(1) NOT NULL DEFAULT 1,
  is_locked         TINYINT(1) NOT NULL DEFAULT 0,
  visibility        VARCHAR(32) NOT NULL DEFAULT 'public', 
  -- 'public','logged_in','char_gated'
  min_role_required VARCHAR(32) NOT NULL DEFAULT 'reader', 
  -- 'reader','contributor','moderator','admin' (for editing)
  codex_requirements JSON NULL,
  -- e.g. ["CODEX_RUNECRAFTING_INTRO","CODEX_EMERALD_DREAM_SEEN"]
  created_by_user_id INT NOT NULL,
  updated_by_user_id INT NOT NULL,
  created_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at        TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

Notes:

- `tags` can be a comma-separated string or JSON array (implementation choice).
- `codex_requirements` is used for **character-gated pages** (see §5).

### 3.2 `wiki_page_versions`

Tracks version history for rollback/audit.

```sql
CREATE TABLE IF NOT EXISTS wiki_page_versions (
  id                INT AUTO_INCREMENT PRIMARY KEY,
  page_id           INT NOT NULL,
  version_number    INT NOT NULL,
  title             VARCHAR(256) NOT NULL,
  summary           VARCHAR(512) NULL,
  content_markdown  MEDIUMTEXT NOT NULL,
  category          VARCHAR(64) NOT NULL,
  tags              VARCHAR(512) NULL,
  icon              VARCHAR(128) NULL,
  visibility        VARCHAR(32) NOT NULL,
  min_role_required VARCHAR(32) NOT NULL,
  codex_requirements JSON NULL,
  edited_by_user_id INT NOT NULL,
  edited_at         TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  comment           VARCHAR(512) NULL,
  INDEX idx_page_version (page_id, version_number),
  CONSTRAINT fk_wiki_page_versions_page
    FOREIGN KEY (page_id) REFERENCES wiki_pages(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.3 Optional: `wiki_page_links`

If needed later for link graphs / backlink navigation:

```sql
CREATE TABLE IF NOT EXISTS wiki_page_links (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  from_page_id    INT NOT NULL,
  to_page_id      INT NOT NULL,
  link_text       VARCHAR(256) NULL,
  created_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX idx_from_page (from_page_id),
  INDEX idx_to_page   (to_page_id),
  CONSTRAINT fk_wiki_links_from
    FOREIGN KEY (from_page_id) REFERENCES wiki_pages(id)
    ON DELETE CASCADE,
  CONSTRAINT fk_wiki_links_to
    FOREIGN KEY (to_page_id) REFERENCES wiki_pages(id)
    ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

(This is optional; can be added later once basic wiki is functional.)

---

## 4. Roles & Permissions

Reuse Atlas auth with a wiki-specific subset:

- **Reader** (default logged-out/guest):
  - Can view `public` pages.
- **User** (logged-in player):
  - Can view `logged_in` pages.
  - Can view `char_gated` pages if their selected character satisfies Codex requirements.
- **Contributor**:
  - Can create new pages (unlocked categories),
  - Can edit existing pages that are not locked,
  - Changes may require Moderator/Admin approval (configurable).
- **Moderator**:
  - Can edit/lock/unlock pages,
  - Can revert to previous versions,
  - Can mark contributions as approved.
- **Admin**:
  - Full control; can delete pages, change categories/visibility/requirements.

Permission rules:

- A **page is visible** if:
  - `visibility = 'public'` → everyone,
  - `visibility = 'logged_in'` → require authenticated user,
  - `visibility = 'char_gated'` → require:
    - authenticated user **and**
    - selected character with required Codex flags/conditions.
- A **page is editable** if:
  - User role ≥ `min_role_required` **and**
  - Page is not `is_locked` (or user is Moderator/Admin).

---

## 5. Game Integration (Character-Gated Pages)

For “in-world” flavor, the wiki can gate some pages so they **only appear after your character learns/discovers that info**.

### 5.1 Codex Requirements

- `codex_requirements` is a JSON array of requirement keys, e.g.:

  ```json
  ["CODEX_RUNECRAFTING_INTRO", "CODEX_EMERALD_DREAM_SEEN"]
  ```

- Atlas needs an API endpoint to fetch a character’s unlocked codex flags, or it can:
  - Proxy to game backend,
  - Or read from a replicated view/table exposed to Atlas.

### 5.2 Visibility Logic

For `visibility = 'char_gated'`:

- If no character is attached/selected:
  - Show a “Discoverable” stub or nothing (configurable).
- If character is attached:
  - Check codex flags:
    - If all required flags present → page visible.
    - Else → show “???” or redacted preview (“Your character has not discovered this yet.”).

This reinforces progression and makes the wiki feel **diegetic**, not just an external manual.

---

## 6. Backend API (Go + Gin)

Base path: `/api/wiki`

### 6.1 Public/Reader Endpoints

- `GET /api/wiki`
  - Query params:
    - `q` (search string),
    - `tag`,
    - `category`,
    - `page`, `pageSize`.
  - Returns list of pages (id, slug, title, summary, category, tags, icon).
  - Applies visibility filters based on auth + character context.

- `GET /api/wiki/:slug`
  - Returns full page content:
    - Current version fields,
    - Minimal metadata (author, updated_at).
  - Applies visibility and gating.

- `GET /api/wiki/:slug/versions` (optional for readers)
  - List of version metadata only (version numbers, edited_at, edited_by, comment).
  - Full content only accessible to Moderator/Admin or via specific inspect endpoint.

### 6.2 Contributor/Editor Endpoints

- `POST /api/wiki`
  - Create new page.
  - Requires role ≥ `contributor`.
  - Body:
    - `slug`, `title`, `summary`, `content_markdown`, `category`, `tags`, `icon`,
    - `visibility`, `min_role_required`, `codex_requirements`.
  - On success:
    - Insert into `wiki_pages`,
    - First record in `wiki_page_versions` with version_number = 1.

- `PUT /api/wiki/:slug`
  - Edit page.
  - Requires:
    - Role ≥ `min_role_required` for that page,
    - Page not locked, or user is Moderator/Admin.
  - On success:
    - Increment version_number,
    - Insert into `wiki_page_versions`,
    - Update `wiki_pages` with new content.

- `POST /api/wiki/:slug/revert`
  - Revert to previous version.
  - Requires Moderator or Admin.
  - Body:
    - `version_number`,
    - Optional `comment`.
  - On success:
    - Copy fields from version into `wiki_pages`,
    - Create new `wiki_page_versions` record representing the revert.

### 6.3 Admin/Moderation Endpoints

- `POST /api/wiki/:slug/lock`
  - `is_locked = true`.

- `POST /api/wiki/:slug/unlock`

- `DELETE /api/wiki/:slug`
  - Soft delete or full delete (implementation choice).
  - Requires Admin.

### 6.4 Supporting Endpoints

- `GET /api/wiki/tags`
  - Returns list of used tags with counts.

- `GET /api/wiki/categories`
  - Returns list of categories with counts.

---

## 7. Frontend (React + TS + Tailwind)

### 7.1 Routes

- `/wiki`
  - Wiki home:
    - Search bar,
    - Category + tag filters,
    - List of featured/recent pages,
    - Possibly “New to Mortal Warcraft? Start here” section.

- `/wiki/search`
  - Search results page:
    - Accepts query param `q`,
    - Shows results list with snippets.

- `/wiki/tags/:tag`
  - Filtered page showing all pages with the given tag.

- `/wiki/category/:category`
  - Filtered page for a specific category.

- `/wiki/:slug`
  - Individual page view:
    - Title, metadata, content (markdown rendered),
    - Tags, category, breadcrumbs,
    - “Last updated” info,
    - “See also” (related pages by tags/category),
    - If editor permissions:
      - “Edit Page” button.

- `/wiki/:slug/edit`
  - Editor view:
    - Title field,
    - Summary,
    - Markdown editor (with preview),
    - Category, tags, icon selector,
    - Visibility & gating controls,
    - Save / Cancel.

### 7.2 Components

- `WikiLayout`
  - Shared layout for all wiki pages:
    - Sidebar with categories, tags, quick links.
- `WikiSearchBar`
- `WikiTagList`
- `WikiCategoryList`
- `WikiPageList`
- `WikiMarkdownRenderer`
  - Renders markdown with:
    - Code block styling,
    - Tables,
    - In-page anchor links.
- `WikiEditor`
  - Markdown text area with live preview tab,
  - Validation for fields,
  - Unsaved changes warnings.

---

## 8. Auth & Character Context

- The portal already handles JWT auth.
- For character-gated pages, the wiki frontend needs **character context**:
  - Either from:
    - A character selector in Atlas,
    - Or account linking to a primary character.
- Requests to `/api/wiki` can include:
  - `characterId` or similar,
  - So backend can evaluate Codex requirements (via game integration).

If no character is selected:

- For `visibility = 'char_gated'` pages, the UI can:
  - Hide them,
  - Or show them as locked entries (“Discoverable in-game”).

---

## 9. Integrations & Future Enhancements

### 9.1 Link Helpers

- Markdown helper syntax for linking to other wiki pages, e.g.:
  - `[[Dynamic Level]]` → internal wiki link to slug `dynamic-level`.

### 9.2 Autogenerated Pages

- Later, Atlas could auto-generate skeleton pages for:
  - Zones,
  - Strongholds,
  - World bosses,
  - Named events,
  - Item tiers.

These can then be manually expanded by contributors.

### 9.3 Developer/Spec Mirror

- Optionally expose some of the **design/spec docs** (or curated extracts) as “Developer” category pages for transparency, without leaking internal ops secrets.

---

## 10. Implementation Checklist

1. **Backend**
   - Add `wiki_pages`, `wiki_page_versions` (and optionally `wiki_page_links`).
   - Implement `/api/wiki` endpoints with role and visibility checks.
   - Integrate Codex/character gating via existing or new game-data API.
2. **Frontend**
   - Add wiki routes and layout.
   - Implement page list, read view, and editor.
   - Hook up auth and role-based UI (hide edit controls for non-contributors).
3. **Integration**
   - Add “Wiki” navigation entry to Atlas main nav.
   - Add cross-links from:
     - Map overlays to relevant wiki pages,
     - Killboard (e.g., link to world boss page),
     - Market tracker (link to material/gear tier pages).
4. **Content Bootstrapping**
   - Seed initial pages:
     - Getting Started,
     - Core Systems (Full Loot, Shrines, Blessed Items, Regional Banks),
     - Zones and Risk Tiers,
     - Mastery Trees overview.
5. **Telemetry & Moderation**
   - Log wiki edits and page views.
   - Add basic UI for Moderators to:
     - See recent edits,
     - Lock/revert problematic pages.

