#ifndef CHARACTER_DATABASE_MORTAL_H
#define CHARACTER_DATABASE_MORTAL_H

// Character Database Prepared Statements for Mortal Overhaul
// Add these to your CharacterDatabase.cpp prepared statements enum

// Example enum additions (add to existing CharacterStatements enum):
/*
    CHAR_SEL_MORTAL_ALL_SKILLS = MAX_CHARACTERDATABASE_STATEMENTS,
    CHAR_SEL_MORTAL_SKILL,
    CHAR_REP_MORTAL_SKILL,
    CHAR_SEL_MORTAL_REGIONAL_BANK,
    CHAR_REP_MORTAL_REGIONAL_BANK_ITEM,
    
    // Criminal Flags (spec 02-combat, 03-risk-zones, 11-pvp-systems)
    CHAR_SEL_MORTAL_CRIMINAL_FLAG,
    CHAR_REP_MORTAL_CRIMINAL_FLAG,
    CHAR_DEL_MORTAL_CRIMINAL_FLAG,
    CHAR_DEL_EXPIRED_MORTAL_CRIMINAL_FLAGS,
    
    // Notoriety System (spec 11-pvp-systems)
    CHAR_SEL_MORTAL_NOTORIETY,
    CHAR_INS_OR_UPD_MORTAL_NOTORIETY,
    CHAR_DEL_MORTAL_NOTORIETY,
    CHAR_UPD_MORTAL_NOTORIETY_DECAY,
    CHAR_UPD_MORTAL_NOTORIETY_BULK_DECAY,
*/

// SQL Queries (add to CharacterDatabase.cpp PrepareStatements()):

/*
    // Get all skills for character (for loading into memory)
    PREPARE_STATEMENT(CHAR_SEL_MORTAL_ALL_SKILLS, 
        "SELECT skill_id, value, max_value, state FROM character_mortal_skills WHERE guid = ?", 
        CONNECTION_SYNCH);
    
    // Get specific skill value for character
    PREPARE_STATEMENT(CHAR_SEL_MORTAL_SKILL, 
        "SELECT value FROM character_mortal_skills WHERE guid = ? AND skill_id = ?", 
        CONNECTION_SYNCH);
    
    // Insert or update skill (with new schema: value is FLOAT, state included)
    PREPARE_STATEMENT(CHAR_REP_MORTAL_SKILL,
        "REPLACE INTO character_mortal_skills (guid, skill_id, value, max_value, state) VALUES (?, ?, ?, ?, ?)",
        CONNECTION_ASYNC);
    
    // Get regional bank items (using zone_id instead of region_id)
    PREPARE_STATEMENT(CHAR_SEL_MORTAL_REGIONAL_BANK,
        "SELECT slot, item_guid, item_entry, count FROM character_regional_bank WHERE guid = ? AND zone_id = ?",
        CONNECTION_SYNCH);
    
    // Insert or update regional bank item
    PREPARE_STATEMENT(CHAR_REP_MORTAL_REGIONAL_BANK_ITEM,
        "REPLACE INTO character_regional_bank (guid, zone_id, slot, item_guid, item_entry, count) VALUES (?, ?, ?, ?, ?, ?)",
        CONNECTION_ASYNC);
    
    // ===== CRIMINAL FLAGS =====
    // Get criminal flag expiry time (0 if not flagged)
    PREPARE_STATEMENT(CHAR_SEL_MORTAL_CRIMINAL_FLAG,
        "SELECT criminal_until FROM character_criminal_flags WHERE guid = ? LIMIT 1",
        CONNECTION_SYNCH);
    
    // Set or update criminal flag
    PREPARE_STATEMENT(CHAR_REP_MORTAL_CRIMINAL_FLAG,
        "REPLACE INTO character_criminal_flags (guid, criminal_until) VALUES (?, ?)",
        CONNECTION_ASYNC);
    
    // Delete criminal flag
    PREPARE_STATEMENT(CHAR_DEL_MORTAL_CRIMINAL_FLAG,
        "DELETE FROM character_criminal_flags WHERE guid = ?",
        CONNECTION_ASYNC);
    
    // Delete all expired criminal flags
    PREPARE_STATEMENT(CHAR_DEL_EXPIRED_MORTAL_CRIMINAL_FLAGS,
        "DELETE FROM character_criminal_flags WHERE criminal_until <= ?",
        CONNECTION_ASYNC);
    
    // ===== NOTORIETY SYSTEM =====
    // Get notoriety value
    PREPARE_STATEMENT(CHAR_SEL_MORTAL_NOTORIETY,
        "SELECT notoriety FROM character_notoriety WHERE guid = ? LIMIT 1",
        CONNECTION_SYNCH);
    
    // Insert or update notoriety
    PREPARE_STATEMENT(CHAR_INS_OR_UPD_MORTAL_NOTORIETY,
        "INSERT INTO character_notoriety (guid, notoriety, last_updated) VALUES (?, ?, ?) "
        "ON DUPLICATE KEY UPDATE notoriety = notoriety + ?, last_updated = ?",
        CONNECTION_ASYNC);
    
    // Delete notoriety record
    PREPARE_STATEMENT(CHAR_DEL_MORTAL_NOTORIETY,
        "DELETE FROM character_notoriety WHERE guid = ?",
        CONNECTION_ASYNC);
    
    // Decay notoriety for specific player
    PREPARE_STATEMENT(CHAR_UPD_MORTAL_NOTORIETY_DECAY,
        "UPDATE character_notoriety SET notoriety = ?, last_updated = ? WHERE guid = ?",
        CONNECTION_ASYNC);
    
    // Bulk decay all notoriety values by 1 point (called once per hour)
    PREPARE_STATEMENT(CHAR_UPD_MORTAL_NOTORIETY_BULK_DECAY,
        \"UPDATE character_notoriety SET notoriety = IF(notoriety > 1, notoriety - 1, 0), last_updated = ? WHERE notoriety > 0\",
        CONNECTION_ASYNC);
    
    // ===== BOUNTY SYSTEM =====
    // Get total bounty amount on a player
    PREPARE_STATEMENT(CHAR_SEL_MORTAL_BOUNTY,
        \"SELECT COALESCE(SUM(bounty_amount), 0) FROM mortal_bounties WHERE target_guid = ? AND is_claimed = 0\",
        CONNECTION_SYNCH);
    
    // Post a new bounty
    PREPARE_STATEMENT(CHAR_INS_MORTAL_BOUNTY,
        \"INSERT INTO mortal_bounties (poster_guid, target_guid, bounty_amount, posted_at) VALUES (?, ?, ?, ?)\",
        CONNECTION_ASYNC);
    
    // Get all unclaimed bounties on a target
    PREPARE_STATEMENT(CHAR_SEL_MORTAL_BOUNTIES_ON_TARGET,
        \"SELECT id, bounty_amount FROM mortal_bounties WHERE target_guid = ? AND is_claimed = 0 ORDER BY posted_at DESC LIMIT 10\",
        CONNECTION_SYNCH);
    
    // Claim a bounty
    PREPARE_STATEMENT(CHAR_UPD_MORTAL_BOUNTY_CLAIM,
        \"UPDATE mortal_bounties SET is_claimed = 1, claimed_by = ?, claimed_at = ? WHERE id = ?\",
        CONNECTION_ASYNC);
    
    // Get claimed bounties for a claimer (within last 30 days)
    PREPARE_STATEMENT(CHAR_SEL_MORTAL_CLAIMED_BOUNTIES,
        \"SELECT id, bounty_amount FROM mortal_bounties WHERE claimed_by = ? AND is_claimed = 1 AND claimed_at > DATE_SUB(NOW(), INTERVAL 30 DAY)\",
        CONNECTION_SYNCH);
    
    // Clear all bounties on a player
    PREPARE_STATEMENT(CHAR_DEL_MORTAL_BOUNTIES_ON_TARGET,
        \"DELETE FROM mortal_bounties WHERE target_guid = ? AND is_claimed = 0\",
        CONNECTION_ASYNC);
*/

#endif // CHARACTER_DATABASE_MORTAL_H

