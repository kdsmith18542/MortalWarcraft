-- Investigation Query for Issue #16905: Druid Berserk (Spell 50334)
-- Run with: mysql -h127.0.0.1 -uroot -p realm2_world < check_spell_50334.sql

-- Check spell definition
SELECT 
    entry,
    name,
    powerType,           -- 0=Mana, 1=Rage, 3=Energy, etc.
    powerCost,
    powerCostPercentage,
    powerPerSecond,
    Effect1,
    Effect2,
    Effect3,
    EffectItemType1,
    EffectItemType2,
    EffectItemType3,
    EffectBasePoints1,
    EffectBasePoints2,
    EffectBasePoints3
FROM spell_template
WHERE entry = 50334;

-- Check spell script
SELECT * FROM spell_script_names WHERE spell_id = 50334;

-- Check linked spells
SELECT * FROM spell_linked_spell WHERE spell_trigger = 50334;

-- Check spell effects that might consume energy
SELECT 
    entry,
    Effect1,
    Effect2,
    Effect3,
    EffectItemType1,
    EffectItemType2,
    EffectItemType3,
    EffectMiscValue1,
    EffectMiscValue2,
    EffectMiscValue3
FROM spell_template
WHERE entry = 50334;

