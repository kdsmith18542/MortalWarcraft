-- Custom corpse chest for PvP loot
-- New entry to avoid reusing Argent Crusade tribute chest
-- Uses displayId 10030 (Argent Crusade Tribute Chest art)

DELETE FROM gameobject_template WHERE entry = 900101;
INSERT INTO gameobject_template (entry, type, displayId, name, IconName, castBarCaption, unk1, size, Data0, Data1, Data2, Data3, Data4, Data5, Data6, Data7, Data8, Data9, Data10, Data11, Data12, Data13, Data14, Data15, Data16, Data17, Data18, Data19, Data20, Data21, Data22, Data23, AIName, ScriptName, VerifiedBuild)
VALUES (
    900101,                  -- entry
    3,                       -- type: Chest
    10030,                   -- displayId
    'Mortal Corpse Chest',   -- name
    '', '', '',              -- IconName, castBarCaption, unk1
    1.0,                     -- size
    0,0,0,0,0,0,0,0,0,0,0,   -- Data0..10
    0,0,0,0,0,0,0,0,0,0,0,0, -- Data11..22
    0,                       -- Data23
    '', '', 0
);
