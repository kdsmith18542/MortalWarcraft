-- Systems Audit Fix #12: Bind Meeting Stone Summon prevention script
-- This binds the spell script to spell ID 23598 (Meeting Stone Summon)
-- The script prevents the spell from being cast, keeping stones as LFG markers only

INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) 
VALUES (23598, 'SpellScript_MortalMeetingStone')
ON DUPLICATE KEY UPDATE `ScriptName` = 'SpellScript_MortalMeetingStone';

