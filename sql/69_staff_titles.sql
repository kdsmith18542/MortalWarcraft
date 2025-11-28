-- ==================================================
-- Mortal Warcraft – Staff Titles
-- Spec 81: Archon and Staff Chat Tags
-- Target DB: characters.chr_titles
-- ==================================================

-- Custom titles for staff roles
-- IDs 300-310 are typically safe in custom spaces

INSERT INTO chr_titles (ID, Condition_ID, NameMale, NameFemale)
VALUES
(300, 0, '%s, Mortal Archon', '%s, Mortal Archon'),
(301, 0, '%s, Sentinel of the Frontier', '%s, Sentinel of the Frontier'),
(302, 0, '%s, Town Warden', '%s, Town Warden')
ON DUPLICATE KEY UPDATE
    NameMale = VALUES(NameMale),
    NameFemale = VALUES(NameFemale);

