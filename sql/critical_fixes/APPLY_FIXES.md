# How to Apply Critical Fixes

This guide explains how to apply the 25 critical fixes to your AzerothCore database.

## Prerequisites

1. **Backup your database** before applying any fixes:
   ```bash
   mysqldump -u root -p acore_world > backup_world_$(date +%Y%m%d).sql
   mysqldump -u root -p acore_characters > backup_characters_$(date +%Y%m%d).sql
   ```

2. **Database access**: Ensure you have MySQL/MariaDB credentials with appropriate privileges

3. **Test environment**: Test fixes in development before applying to production

## Quick Apply (All Fixes)

Apply all 25 fixes at once:

```bash
cd /path/to/MortalWarcraft/sql/critical_fixes

# Apply all fixes to world database
for file in {001..030}_*.sql; do
    if [ -f "$file" ]; then
        echo "Applying $file..."
        mysql -u your_user -p your_database < "$file"
    fi
done
```

## Selective Application

### By Category

#### Spell Mechanics (8 Complete + 9 Partial)
```bash
mysql -u root -p acore_world < 008_prayer_of_healing_los_fix.sql
mysql -u root -p acore_world < 009_replenishment_threat_fix.sql
mysql -u root -p acore_world < 010_shadowmeld_spell_grounding_fix.sql
mysql -u root -p acore_world < 011_shadowfiend_cyclone_interaction_fix.sql
mysql -u root -p acore_world < 012_thunderstorm_clearcasting_fix.sql
mysql -u root -p acore_world < 013_freezing_trap_reflection_fix.sql
mysql -u root -p acore_world < 018_grounding_totem_chain_lightning.sql
mysql -u root -p acore_world < 028_warrior_cleave_sweeping_strikes.sql
mysql -u root -p acore_world < 029_warrior_charge_terrain_climbing.sql
```

#### NPC & Quest Fixes (8 fixes)
```bash
mysql -u root -p acore_world < 002_surveyor_candress_fix.sql
mysql -u root -p acore_world < 006_magmoth_fire_totem_fix.sql
mysql -u root -p acore_world < 016_tahu_sagewind_missing_npc.sql
mysql -u root -p acore_world < 021_lightning_infused_relics_fix.sql
mysql -u root -p acore_world < 022_dun_da_dun_tah_quest_issues.sql
mysql -u root -p acore_world < 023_tinky_wickwhistle_completion_rp.sql
mysql -u root -p acore_world < 024_battle_for_undercity_lifts.sql
```

#### Vehicle & Combat (5 fixes)
```bash
mysql -u root -p acore_world < 014_borean_tundra_siege_tank_fix.sql
mysql -u root -p acore_world < 025_aces_high_quest_issues.sql
mysql -u root -p acore_world < 026_army_of_damned_deathstorm_damage.sql
mysql -u root -p acore_world < 027_assault_by_air_spear_guns.sql
```

#### Profession & Items (3 fixes)
```bash
mysql -u root -p acore_world < 003_blade_of_eternal_darkness_crit.sql
mysql -u root -p acore_world < 004_profession_learning_fix.sql
mysql -u root -p acore_world < 007_forge_of_fate_dalaran_fix.sql
```

#### Raid & Dungeon (2 fixes)
```bash
mysql -u root -p acore_world < 020_utgarde_pinnacle_call_flames_timing.sql
mysql -u root -p acore_world < 030_ulduar_thorim_chain_lightning_range.sql
```

### By Priority

#### High Priority (Server Stability & Exploits)
```bash
mysql -u root -p acore_world < 004_profession_learning_fix.sql
mysql -u root -p acore_world < 005_eots_immunity_death_fix.sql
mysql -u root -p acore_world < 009_replenishment_threat_fix.sql
mysql -u root -p acore_world < 017_healer_aggro_range_fix.sql
mysql -u root -p acore_world < 021_lightning_infused_relics_fix.sql
mysql -u root -p acore_world < 026_army_of_damned_deathstorm_damage.sql
```

#### Medium Priority (Gameplay & Balance)
```bash
mysql -u root -p acore_world < 002_surveyor_candress_fix.sql
mysql -u root -p acore_world < 006_magmoth_fire_totem_fix.sql
mysql -u root -p acore_world < 012_thunderstorm_clearcasting_fix.sql
mysql -u root -p acore_world < 014_borean_tundra_siege_tank_fix.sql
mysql -u root -p acore_world < 020_utgarde_pinnacle_call_flames_timing.sql
mysql -u root -p acore_world < 025_aces_high_quest_issues.sql
mysql -u root -p acore_world < 028_warrior_cleave_sweeping_strikes.sql
mysql -u root -p acore_world < 029_warrior_charge_terrain_climbing.sql
mysql -u root -p acore_world < 030_ulduar_thorim_chain_lightning_range.sql
```

#### Low Priority (Polish & QoL)
```bash
mysql -u root -p acore_world < 015_combo_point_visual_fix.sql
mysql -u root -p acore_world < 016_tahu_sagewind_missing_npc.sql
mysql -u root -p acore_world < 019_eating_talent_point_animation.sql
mysql -u root -p acore_world < 023_tinky_wickwhistle_completion_rp.sql
```

## Verification

After applying fixes, verify they were applied correctly:

```sql
-- Check SAI scripts were added
SELECT COUNT(*) FROM smart_scripts WHERE entryorguid IN (25444, 34528, 26814);

-- Check creature spawns
SELECT * FROM creature WHERE id IN (34528);

-- Check spell modifications (if spell_dbc table exists)
-- SELECT Id, SpellName FROM spell_dbc WHERE Id IN (57669, 58912);

-- Check spell scripts registered
SELECT COUNT(*) FROM spell_script_names WHERE ScriptName LIKE 'spell_%';
```

## Rollback Procedure

If you need to rollback:

```bash
# Restore from backup
mysql -u root -p acore_world < backup_world_YYYYMMDD.sql
mysql -u root -p acore_characters < backup_characters_YYYYMMDD.sql
```

Or selectively remove fixes:

```sql
-- Remove specific SAI scripts
DELETE FROM smart_scripts WHERE entryorguid IN (25444, 26814, 34528);

-- Remove specific creature spawns
DELETE FROM creature WHERE id = 34528;

-- Remove spell scripts
DELETE FROM spell_script_names WHERE ScriptName LIKE 'spell_%_fix%';
```

## Testing After Application

1. **Restart your server** to apply changes:
   ```bash
   ./acore.sh worldserver restart
   ```

2. **Test critical fixes** in-game:
   ```
   .gm on
   .go creature id 25444   # Test Magmoth Fire Totem
   .go creature id 34528   # Test Tahu Sagewind
   .quest add 13413        # Test Aces High
   ```

3. **Monitor server logs** for any errors:
   ```bash
   tail -f worldserver.log | grep -i "error\|warning"
   ```

## Known Limitations

- **17 fixes require C++ implementation** for complete functionality
- SQL scripts provide mitigation and database preparation
- Some fixes may not work until corresponding C++ code is added to core
- See README.md Support Matrix for details on which fixes need core modifications

## Need Help?

- Review individual SQL files for verification queries
- Check README.md for detailed fix descriptions
- Test in development environment first
- Restore from backup if issues arise

## Additional Resources

- [AzerothCore Wiki](https://www.azerothcore.org/wiki/)
- [WoWDev Wiki](https://wowdev.wiki/)
- [WoWHead Database](https://www.wowhead.com/wotlk)
- [Upstream Issue Tracker](https://github.com/azerothcore/azerothcore-wotlk/issues)
