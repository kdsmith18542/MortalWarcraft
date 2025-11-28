# Project Canvas: Mortal Warcraft Overhaul
### Version 28.0 — Hybrid Technical Design Document  
### File: 38-social-and-onboarding-systems.md  
### Section: Social Tools, Group Finding & Onboarding (Expeditions, LFG, Guilds, Codex, Mercy)

---

## 1. Purpose

Define social and onboarding systems that:

- Preserve the **sandbox feel** (Mortal Online / EVE style, world-first).
- Provide **accessible group-finding** and **structured content access**.
- Help new and returning players understand:
  - Harsh rules (full loot, red zones, decay),
  - Available activities (PvE, PvP, trade, strongholds).
- Reduce early churn without removing risk.

This spec covers:

1. **Expedition Finder** – non-teleport dungeon group finder with staging camps.
2. **LFG Board** – generalized “Looking For Group” listings for sandbox activities.
3. **Guild Directory** – discoverable guilds with activity tags and applications.
4. **Mortal Codex** – in-game help / manual for Mortal systems.
5. **Red-Zone Warnings & First-Death Mercy** – expectation setting + one-time forgiveness.

---

## Related Specs

For full context on social and onboarding systems, see:

- **`09-social-systems.md`** — Core social systems (taverns, mini-games) that complement onboarding
- **`18-lfg-warfront-ui.md`** — LFG Board and Expedition Finder UI systems
- **`47-mentoring-and-build-loadouts.md`** — Mentor system for early respecs and guidance
- **`03-risk-zones.md`** — Risk zones that onboarding explains
- **`01-progression.md`** — Progression system that onboarding introduces
- **`88-mortal-progression-era-map.md`** — Progression eras that onboarding guides players through
- **`15-ui-client.md`** — UI systems that support onboarding

---

## 2. Expedition Finder (Dungeon Group Finder)

### 2.1 Concept

Expedition Finder is a **world-aware group finder** for instanced dungeons and raids:

- Players can queue/form groups using UI or NPCs.
- The system **matches groups**, but:
  - Does **not** teleport players directly into instances.
  - Optionally transports them to **staging camps** near the entrance.

Public (de-instanced) dungeons are **not** managed by Expedition Finder and remain pure sandbox.

### 2.2 Core Rules

- Expedition Finder is **available from**:
  - Capital cities (War Rooms / Adventurer Halls),
  - Major inns,
  - MortalUI panel when the player is in a rested area.
- When a group is formed:
  - Players are notified,
  - Can accept/decline,
  - If accepted, may:
    - Receive optional transport to staging camp,
    - Or travel manually.

No cross-map teleport from wild zones.

### 2.3 Data Model

#### 2.3.1 Expedition Definitions

```sql
CREATE TABLE IF NOT EXISTS mortal_expedition_def (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  code            VARCHAR(64) NOT NULL,     -- 'EXP_DEADMINES_MT1', 'EXP_SCHOLO_MT3'
  map_id          INT NOT NULL,            -- instance map id
  min_skill_band  INT NOT NULL DEFAULT 0,  -- approximate Mortal level min
  max_skill_band  INT NOT NULL DEFAULT 999,
  suggested_roles VARCHAR(64) NULL,        -- 'frontline:1,ranged:1,support:1'
  staging_camp_id INT NOT NULL,            -- FK to staging camp data (world location)
  difficulty      VARCHAR(16) NOT NULL,    -- 'NORMAL','HARD','HEROIC'
  flags           INT NOT NULL DEFAULT 0,  -- 1 = heroic only, 2 = lockout, etc.
  notes           VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### 2.3.2 Expedition Listings (Queue Entries)

```sql
CREATE TABLE IF NOT EXISTS mortal_expedition_listing (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  def_id          INT NOT NULL,          -- FK to mortal_expedition_def
  leader_guid     INT NOT NULL,          -- characters.guid of listing owner
  created_time    INT NOT NULL,
  desired_roles   VARCHAR(64) NULL,      -- desired roles: 'frontline:1,ranged:1,support:1'
  comment         VARCHAR(255) NULL,     -- free text e.g. 'chill run, learning ok'
  min_rating      INT NOT NULL DEFAULT 0, -- optional: PvE score requirement
  flags           INT NOT NULL DEFAULT 0, -- hardcore, voice required, etc.
  state           TINYINT NOT NULL DEFAULT 0  -- 0=open,1=matched,2=cancelled
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### 2.3.3 Expedition Member Slots (Optional)

If needed for more detailed control:

```sql
CREATE TABLE IF NOT EXISTS mortal_expedition_member (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  listing_id      INT NOT NULL,          -- FK to mortal_expedition_listing
  guid            INT NOT NULL,          -- characters.guid
  role            VARCHAR(16) NOT NULL,  -- 'frontline','ranged','support','utility'
  status          TINYINT NOT NULL DEFAULT 0  -- 0=pending,1=accepted,2=declined
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 2.4 Staging Camps

#### 2.4.1 Concept

Each instanced dungeon/raid has a **nearby staging camp**:

- Non-instanced area with:
  - Repairs, vendors, classless dummy NPC, Task Board hooks.
- Acts as:
  - A rendezvous point for Expedition groups.

#### 2.4.2 Schema

```sql
CREATE TABLE IF NOT EXISTS mortal_staging_camp (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  name            VARCHAR(64) NOT NULL,
  map_id          INT NOT NULL,
  position_x      FLOAT NOT NULL,
  position_y      FLOAT NOT NULL,
  position_z      FLOAT NOT NULL,
  orientation     FLOAT NOT NULL,
  linked_expedition_code VARCHAR(64) NOT NULL,  -- FK by code to expedition_def
  flags           INT NOT NULL DEFAULT 0,       -- future use (pvp enabled, etc.)
  notes           VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 2.5 Flow

1. Player interacts with Expedition NPC or MortalUI in capital/inn.
2. Chooses:
   - Desired instance (from `mortal_expedition_def`),
   - Role,
   - Preferences (casual/hardcore).
3. System:
   - Either:
     - Joins an existing `mortal_expedition_listing`,
     - Or creates a new listing as leader.
4. When a compatible group is formed:
   - All members get a popup:
     - “Expedition to [Dungeon] ready. Travel to [Staging Camp]?”
   - If in a capital/inn:
     - Can accept and **teleport** to the staging camp.
   - If not:
     - Must travel manually (or wait until in a hub).

5. Once gathered at staging camp:
   - Player-run group decides when to enter instance portal.

---

## 3. LFG Board (General Activities)

### 3.1 Concept

LFG Board is a more general **“bulletin board”** system for:

- Custom dungeon runs,
- Trade caravans & escorts,
- Red-zone roam/warbands,
- Public dungeon zergs, etc.

It reuses similar listing concepts but is **not tied to a specific dungeon_def**.

### 3.2 Data Model

```sql
CREATE TABLE IF NOT EXISTS mortal_lfg_listing (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  leader_guid     INT NOT NULL,
  created_time    INT NOT NULL,
  activity_type   VARCHAR(32) NOT NULL,  -- 'DUNGEON','TRADE_RUN','REDZONE_PVP','PUBLIC_DUNGEON'
  title           VARCHAR(64) NOT NULL,  -- 'T3 Trade Run STV -> IF'
  description     VARCHAR(255) NULL,     -- free text
  zone_id         INT NULL,              -- primary zone (optional)
  risk_tier       VARCHAR(8) NULL,       -- 'T_G','T_Y','T_R'
  desired_roles   VARCHAR(64) NULL,      -- 'frontline:2,ranged:2,support:1'
  min_skill_band  INT NOT NULL DEFAULT 0,
  max_skill_band  INT NOT NULL DEFAULT 999,
  flags           INT NOT NULL DEFAULT 0, -- e.g. 1=voice,2=hardcore
  state           TINYINT NOT NULL DEFAULT 0  -- 0=open,1=closed
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 3.3 Access

- Physical LFG Board NPCs:
  - In capitals, taverns, staging camps.
- MortalUI LFG panel:
  - Shows the same listings; players can:
    - Filter by activity type, risk tier, zone.
    - Apply to listings or create their own.

**No teleportation** is tied to LFG; it’s purely for **group discovery**.

---

## 4. Guild Directory & Applications

### 4.1 Concept

Players need an easy way to:

- Discover guilds that match their playstyle.
- Apply or auto-join open guilds.

### 4.2 Data Model (Guild Metadata)

```sql
CREATE TABLE IF NOT EXISTS mortal_guild_profile (
  guild_id        INT PRIMARY KEY,            -- guild.id
  description     VARCHAR(255) NULL,
  activity_tags   VARCHAR(128) NULL,         -- 'PVE,PVP,TRADE,RP,CASUAL,HARDCORE'
  primary_timezone VARCHAR(32) NULL,         -- 'NA','EU','OCE','Mixed'
  voice_required  TINYINT NOT NULL DEFAULT 0,
  recruitment_status TINYINT NOT NULL DEFAULT 1, -- 0=closed,1=open,2=invite-only
  min_skill_band  INT NOT NULL DEFAULT 0,
  max_skill_band  INT NOT NULL DEFAULT 999,
  last_updated    INT NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4.3 Applications

```sql
CREATE TABLE IF NOT EXISTS mortal_guild_application (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  guild_id        INT NOT NULL,
  applicant_guid  INT NOT NULL,
  created_time    INT NOT NULL,
  message         VARCHAR(255) NULL,
  state           TINYINT NOT NULL DEFAULT 0,  -- 0=pending,1=accepted,2=declined,3=withdrawn
  notes           VARCHAR(255) NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 4.4 Flow

- Player opens **Guild Directory** (via NPC Herald or MortalUI):
  - Filters by tags, timezone, size, recruitment status.
- Selects a guild:
  - Sees description, requirements, contact info.
- If `recruitment_status`:
  - **Open (1)**:
    - Can join instantly (optional).
  - **Invite-only (2)**:
    - Sends application; officers review via GM/guild UI.

---

## 5. Mortal Codex (Help / Manual)

### 5.1 Concept

An in-game **Codex UI** that explains Mortal’s core systems in short, readable sections:

- Zones & risk (Green/Yellow/Red).
- Full loot & corpse chests.
- Regional banking, markets, trade runs.
- Task Boards, Buy Orders, Hot Zones.
- Strongholds, Warfronts, Bounty Boards.
- Blessed items & durability.

### 5.2 Content Structure

Codex entries are stored as simple text/markup rows to allow updates without patching client UI.

```sql
CREATE TABLE IF NOT EXISTS mortal_codex_entry (
  id              INT AUTO_INCREMENT PRIMARY KEY,
  category        VARCHAR(32) NOT NULL,     -- 'ZONES','ECONOMY','PVP','STRONGHOLDS'
  code            VARCHAR(64) NOT NULL,     -- 'ZONES_OVERVIEW','RED_ZONES','TASK_BOARDS'
  title           VARCHAR(64) NOT NULL,
  body_text       TEXT NOT NULL,            -- formatted server-side, rendered in UI
  sort_order      INT NOT NULL DEFAULT 0,
  flags           INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

### 5.3 Access & Integration

- Accessible via:
  - UI button (MortalUI),
  - Certain NPCs (Mentor, Keepers).
- Can be **context-triggered**:
  - Enter Red Zone for first time → auto-open “Red Zones & Full Loot” entry.
  - Visit a bank → suggest “Regional Banking” entry.

---

## 6. Red-Zone Warnings & First-Death Mercy

### 6.1 Red-Zone Entry Warning

On first entry into any Red Zone per character:

- Server sends a custom opcode to client to display a warning:

> **Warning: You are entering a Full Loot Zone.**  
> If you die here, *all items* you carry may be lost to other players.  
> Store valuables in a bank or bless key items at a Shrine.

- Checkbox:
  - “Don’t show this again on this character.”

### 6.2 First-Death Mercy (Per Character, Optional)

To soften first full-loss experience:

#### 6.2.1 Data Model

```sql
CREATE TABLE IF NOT EXISTS mortal_redzone_mercy (
  guid            INT PRIMARY KEY,   -- characters.guid
  used            TINYINT NOT NULL DEFAULT 0,
  granted_time    INT NULL           -- when mercy was used
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
```

#### 6.2.2 Flow

1. Player dies in a Red Zone.
2. Check `mortal_redzone_mercy`:
   - If `used = 0`:
     - At the Shrine, present dialog:

       > “This world is unforgiving. Once, and only once, I can return what you lost.  
       > Use this mercy now?”

     - Options:
       - **Yes**:
         - Restore corpse chest contents to player (or bank),
         - Set `used = 1`.
       - **No**:
         - Do nothing; remain eligible until they choose to use it on a future death.
   - If `used = 1`:
     - No mercy offered; normal full loot applies.

This preserves full-loot identity but adds one emotional safety valve per character.

---

## 7. Integration & Access Points

### 7.1 NPCs

- **Expedition Master NPCs**:
  - Located in capital War Rooms, some staging camps.
  - Open Expedition Finder UI.
- **LFG Board NPCs**:
  - Physical boards in capitals, taverns, staging camps.
  - Open LFG listings UI.
- **Guild Herald NPCs**:
  - In capitals, open Guild Directory UI.
- **Mentor NPC**:
  - Offers:
    - Early-game respec rules (previous spec),
    - Access to key Codex entries.

### 7.2 MortalUI Panels

- **Expedition** panel:
  - Show expedition definitions, queues, your role, and staging camp info.
- **LFG** panel:
  - Browsable postings filtered by type, tier, zone.
- **Guild** panel:
  - Directory, applications, guild profile editing for officers.
- **Codex** panel:
  - Categories, entries, search.

---

## 8. Status

This spec:

- Adds structured but **world-respecting** group tools (Expedition Finder, LFG Board).
- Makes **guild discovery** and social grouping tractable for new players.
- Provides an in-game **Mortal Codex** to explain harsh systems.
- Adds **Red-Zone warnings** and a **one-time mercy** to reduce early rage quits.

These systems help bridge the gap between a **brutally honest sandbox** and the reality that players need:

- Clear goals,
- Clear information,
- And reliable ways to find groups and communities.
