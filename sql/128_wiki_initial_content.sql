-- ==================================================
-- Project Mortal Warcraft
-- Feature: Initial Wiki Content
-- Description: Creates initial wiki articles
-- Based on: docs/specs/24-web-portal-wiki.md
-- ==================================================

-- Wiki Articles
INSERT INTO `webportal_wiki` (`title`, `slug`, `content`, `category_id`, `author_id`, `is_published`, `views`, `created_at`, `updated_at`) VALUES
('Welcome to Mortal Warcraft', 'welcome', '# Welcome to Mortal Warcraft

Mortal Warcraft is a hardcore, full-loot PvP server with deep crafting, dynamic progression, and meaningful choices.

## Getting Started

1. Create your character
2. Learn the basics of combat
3. Explore the world
4. Join a faction
5. Master your skills

## Key Features

- **Dynamic Level System**: Your level is based on your skills
- **Full-Loot PvP**: Risk vs reward in PvP zones
- **Deep Crafting**: Create powerful gear and items
- **Faction System**: Join one of four world factions
- **Season Challenges**: Complete challenges for rewards

Good luck, and may the best survive!', 
(SELECT id FROM wiki_categories WHERE name = 'General' LIMIT 1),
1, 1, 0, 0, 0),
('Combat System', 'combat-system', '# Combat System

Mortal Warcraft features a custom combat system with:

## Core Mechanics

- **Brace**: Reduce incoming damage
- **Hit/Miss**: Based on weapon skill and level
- **Criticals**: Increased damage on critical hits
- **Custom Formulas**: All damage and stats use custom calculations

## Risk Zones

- **Green Zones**: Safe, no PvP
- **Yellow Zones**: Partial loot drop on death
- **Red Zones**: Full loot drop on death

## Crime System

- Commit crimes to gain notoriety
- Become an outlaw for major crimes
- Bounties can be placed on outlaws', 
(SELECT id FROM wiki_categories WHERE name = 'Gameplay' LIMIT 1),
1, 1, 0, 0, 0),
('Factions', 'factions', '# Factions

Mortal Warcraft features four world factions:

## The Iron Ledger
Crafting consortium and trade cartel. Focus on crafting, refining, and logistics.

## Order of the Shrine
Religious order focused on defense and protection. Focus on healing and support.

## Black Sun Cartel
Criminal organization focused on black market and smuggling. Focus on PvP and risk.

## Rangers'' Pact
Explorer and scout organization. Focus on exploration and gathering.

## Pledging

- Pledge to one faction at a time
- Gain standing through faction activities
- Unlock faction rewards and vendors', 
(SELECT id FROM wiki_categories WHERE name = 'Gameplay' LIMIT 1),
1, 1, 0, 0, 0),
('Fishing & First Aid', 'lifeskills', '# Lifeskills: Fishing & First Aid

## Fishing

Fishing is a gathering lifeskill that provides:
- Food components for Cooking
- Reagents for Alchemy
- Special bait for anomalies and rifts

### Skill Lines
- **Fishing: Coastal** - Lakes and seas
- **Fishing: Inland** - Rivers and ponds
- **Fishing: Deep Sea** - Open ocean
- **Fishing: Planar** - Late-game rifts

## First Aid

First Aid is a support lifeskill for:
- Out-of-combat healing
- Debuff removal
- Combat support

### Skill Lines
- **Field Medicine** - General bandaging
- **Trauma Care** - Combat dressings and splints
- **Toxicology** - Antidotes and cures', 
(SELECT id FROM wiki_categories WHERE name = 'Gameplay' LIMIT 1),
1, 1, 0, 0, 0),
('Runes & Augments', 'runes-augments', '# Runes & Augments

## Runes

Runes grant major abilities to gear:
- **Rune of Whirlwind** - Spin attack
- **Rune of Blink** - Short-range teleport
- **Rune of Guard Counter** - Counter-attack after blocking
- **Rune of Thorns** - Reflect damage

## Augments

Augments modify abilities and stats:
- **Offense** - Damage and crit modifiers
- **Defense** - Damage reduction and resistance
- **Utility** - Movement, capacity, and quality of life

## Socketing

- Weapons: 1 rune slot, 2-3 augment slots
- Armor: 0-1 rune slots, 1-2 augment slots
- Accessories: 1 augment slot', 
(SELECT id FROM wiki_categories WHERE name = 'Gameplay' LIMIT 1),
1, 1, 0, 0, 0)
ON DUPLICATE KEY UPDATE `content` = VALUES(`content`), `updated_at` = UNIX_TIMESTAMP();

-- Summary
SELECT 
    'Wiki Articles Created' as summary,
    COUNT(*) as total_articles,
    COUNT(CASE WHEN is_published = 1 THEN 1 END) as published_articles
FROM webportal_wiki;

