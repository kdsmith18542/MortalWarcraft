# AzerothCore Integration Guide
## Adding mod-mortal Prepared Statements

The `mod-mortal` C++ module references custom prepared statements that must be registered in AzerothCore's `CharacterDatabase.h` and `CharacterDatabase.cpp`.

---

### Step 1: Add enum entries to `CharacterDatabase.h`

Open `src/server/database/Database/Implementation/CharacterDatabase.h` and add these entries **before** `MAX_CHARACTERDATABASE_STATEMENTS`:

```cpp
// ===== MORTAL WARCRAFT OVERHOUL - SKILL SYSTEM =====
CHAR_SEL_MORTAL_ALL_SKILLS,
CHAR_SEL_MORTAL_SKILL,
CHAR_REP_MORTAL_SKILL,

// ===== REGIONAL BANKING =====
CHAR_SEL_MORTAL_REGIONAL_BANK,
CHAR_REP_MORTAL_REGIONAL_BANK_ITEM,
CHAR_DEL_MORTAL_REGIONAL_BANK_ITEM,

// ===== CRIMINAL FLAGS =====
CHAR_SEL_MORTAL_CRIMINAL_FLAG,
CHAR_REP_MORTAL_CRIMINAL_FLAG,
CHAR_DEL_MORTAL_CRIMINAL_FLAG,
CHAR_DEL_EXPIRED_MORTAL_CRIMINAL_FLAGS,

// ===== NOTORIETY SYSTEM =====
CHAR_SEL_MORTAL_NOTORIETY,
CHAR_INS_OR_UPD_MORTAL_NOTORIETY,
CHAR_DEL_MORTAL_NOTORIETY,
CHAR_UPD_MORTAL_NOTORIETY_DECAY,
CHAR_UPD_MORTAL_NOTORIETY_BULK_DECAY,

// ===== BOUNTY SYSTEM =====
CHAR_SEL_MORTAL_BOUNTY,
CHAR_INS_MORTAL_BOUNTY,
CHAR_SEL_MORTAL_BOUNTIES_ON_TARGET,
CHAR_UPD_MORTAL_BOUNTY_CLAIM,
CHAR_SEL_MORTAL_CLAIMED_BOUNTIES,
CHAR_DEL_MORTAL_BOUNTIES_ON_TARGET,

// ===== ATTRIBUTES =====
CHAR_SEL_MORTAL_ALL_ATTRIBUTES,
CHAR_REP_MORTAL_ATTRIBUTES,

// ===== STRONGHOLDS =====
CHAR_UPD_MORTAL_STRONGHOLD,
```

### Step 2: Add statements to `CharacterDatabase.cpp`

Open `src/server/database/Database/Implementation/CharacterDatabase.cpp` and add these to the `PrepareStatements()` method. Add them **before** the closing of the switch or after the existing statements:

```cpp
// ===== MORTAL SKILL SYSTEM =====
PrepareStatement(CHAR_SEL_MORTAL_ALL_SKILLS,
    "SELECT skill_id, value, max_value, state FROM character_mortal_skills WHERE guid = ?",
    CONNECTION_SYNCH);

PrepareStatement(CHAR_SEL_MORTAL_SKILL,
    "SELECT value FROM character_mortal_skills WHERE guid = ? AND skill_id = ?",
    CONNECTION_SYNCH);

PrepareStatement(CHAR_REP_MORTAL_SKILL,
    "REPLACE INTO character_mortal_skills (guid, skill_id, value, max_value, state) VALUES (?, ?, ?, ?, ?)",
    CONNECTION_ASYNC);

// ===== REGIONAL BANKING =====
PrepareStatement(CHAR_SEL_MORTAL_REGIONAL_BANK,
    "SELECT slot, item_guid, item_entry, count FROM character_regional_bank WHERE guid = ? AND zone_id = ?",
    CONNECTION_SYNCH);

PrepareStatement(CHAR_REP_MORTAL_REGIONAL_BANK_ITEM,
    "REPLACE INTO character_regional_bank (guid, zone_id, slot, item_guid, item_entry, count) VALUES (?, ?, ?, ?, ?, ?)",
    CONNECTION_ASYNC);

PrepareStatement(CHAR_DEL_MORTAL_REGIONAL_BANK_ITEM,
    "DELETE FROM character_regional_bank WHERE guid = ? AND zone_id = ? AND slot = ?",
    CONNECTION_ASYNC);

// ===== CRIMINAL FLAGS =====
PrepareStatement(CHAR_SEL_MORTAL_CRIMINAL_FLAG,
    "SELECT criminal_until FROM character_criminal_flags WHERE guid = ? LIMIT 1",
    CONNECTION_SYNCH);

PrepareStatement(CHAR_REP_MORTAL_CRIMINAL_FLAG,
    "REPLACE INTO character_criminal_flags (guid, criminal_until) VALUES (?, ?)",
    CONNECTION_ASYNC);

PrepareStatement(CHAR_DEL_MORTAL_CRIMINAL_FLAG,
    "DELETE FROM character_criminal_flags WHERE guid = ?",
    CONNECTION_ASYNC);

PrepareStatement(CHAR_DEL_EXPIRED_MORTAL_CRIMINAL_FLAGS,
    "DELETE FROM character_criminal_flags WHERE criminal_until <= ?",
    CONNECTION_ASYNC);

// ===== NOTORIETY SYSTEM =====
PrepareStatement(CHAR_SEL_MORTAL_NOTORIETY,
    "SELECT notoriety FROM character_notoriety WHERE guid = ? LIMIT 1",
    CONNECTION_SYNCH);

PrepareStatement(CHAR_INS_OR_UPD_MORTAL_NOTORIETY,
    "INSERT INTO character_notoriety (guid, notoriety, last_updated) VALUES (?, ?, ?) "
    "ON DUPLICATE KEY UPDATE notoriety = notoriety + ?, last_updated = ?",
    CONNECTION_ASYNC);

PrepareStatement(CHAR_DEL_MORTAL_NOTORIETY,
    "DELETE FROM character_notoriety WHERE guid = ?",
    CONNECTION_ASYNC);

PrepareStatement(CHAR_UPD_MORTAL_NOTORIETY_DECAY,
    "UPDATE character_notoriety SET notoriety = ?, last_updated = ? WHERE guid = ?",
    CONNECTION_ASYNC);

PrepareStatement(CHAR_UPD_MORTAL_NOTORIETY_BULK_DECAY,
    "UPDATE character_notoriety SET notoriety = IF(notoriety > 1, notoriety - 1, 0), last_updated = ? WHERE notoriety > 0",
    CONNECTION_ASYNC);

// ===== BOUNTY SYSTEM =====
PrepareStatement(CHAR_SEL_MORTAL_BOUNTY,
    "SELECT COALESCE(SUM(bounty_amount), 0) FROM mortal_bounties WHERE target_guid = ? AND is_claimed = 0",
    CONNECTION_SYNCH);

PrepareStatement(CHAR_INS_MORTAL_BOUNTY,
    "INSERT INTO mortal_bounties (poster_guid, target_guid, bounty_amount, posted_at) VALUES (?, ?, ?, ?)",
    CONNECTION_ASYNC);

PrepareStatement(CHAR_SEL_MORTAL_BOUNTIES_ON_TARGET,
    "SELECT id, bounty_amount FROM mortal_bounties WHERE target_guid = ? AND is_claimed = 0 ORDER BY posted_at DESC LIMIT 10",
    CONNECTION_SYNCH);

PrepareStatement(CHAR_UPD_MORTAL_BOUNTY_CLAIM,
    "UPDATE mortal_bounties SET is_claimed = 1, claimed_by = ?, claimed_at = ? WHERE id = ?",
    CONNECTION_ASYNC);

PrepareStatement(CHAR_SEL_MORTAL_CLAIMED_BOUNTIES,
    "SELECT id, bounty_amount FROM mortal_bounties WHERE claimed_by = ? AND is_claimed = 1 AND claimed_at > DATE_SUB(NOW(), INTERVAL 30 DAY)",
    CONNECTION_SYNCH);

PrepareStatement(CHAR_DEL_MORTAL_BOUNTIES_ON_TARGET,
    "DELETE FROM mortal_bounties WHERE target_guid = ? AND is_claimed = 0",
    CONNECTION_ASYNC);

// ===== ATTRIBUTES =====
PrepareStatement(CHAR_SEL_MORTAL_ALL_ATTRIBUTES,
    "SELECT strength, agility, stamina, intellect, spirit FROM character_mortal_attributes WHERE guid = ?",
    CONNECTION_SYNCH);

PrepareStatement(CHAR_REP_MORTAL_ATTRIBUTES,
    "REPLACE INTO character_mortal_attributes (guid, strength, agility, stamina, intellect, spirit) VALUES (?, ?, ?, ?, ?, ?)",
    CONNECTION_ASYNC);

// ===== STRONGHOLDS =====
PrepareStatement(CHAR_UPD_MORTAL_STRONGHOLD,
    "UPDATE mortal_strongholds SET owning_guild = ?, claimed_at = ? WHERE id = ?",
    CONNECTION_ASYNC);
```

### Step 3: Load SQL tables before starting the server

```bash
mysql -u root -p acore_characters < modules/mod-mortal/sql/db_characters/mod_mortal_base.sql
mysql -u root -p acore_world < modules/mod-mortal/sql/db_world/mod_mortal_base.sql
```

### Verify

Check that the server compiles and starts:
```bash
cd azerothcore/build
cmake .. -DMODULES=../../modules/mod-mortal
make -j$(nproc)
```

If it compiles without errors, the integration is complete.
