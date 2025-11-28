-- ==================================================
-- Project Mortal Warcraft
-- Feature: Wiki Articles Content
-- Description: Populates wiki articles for the web portal
-- Based on: docs/specs/49-webportal-wiki-spec.md
-- ==================================================

-- Check which wiki table exists and populate accordingly
-- This script works with both wiki_pages and mortal_wiki_articles schemas

-- For wiki_pages table (from sql/89_webportal_wiki.sql)
INSERT INTO `wiki_pages` (`slug`, `title`, `summary`, `content_markdown`, `category`, `tags`, `is_published`, `visibility`, `created_by_user_id`, `updated_by_user_id`, `created_at`, `updated_at`) VALUES
('welcome', 'Welcome to Mortal Warcraft', 'Introduction to Mortal Warcraft Overhaul', '# Welcome to Mortal Warcraft

Mortal Warcraft is a hardcore, full-loot PvP server with deep crafting, dynamic progression, and meaningful choices.

## Getting Started

1. **Create your character** - Choose your starting path
2. **Learn the basics** - Master combat and survival
3. **Explore the world** - Discover zones and content
4. **Join a faction** - Align with one of four world factions
5. **Master your skills** - Progress through dynamic leveling

## Key Features

### Dynamic Level System
Your level is derived from your total skill points. No traditional XP grinding - progress through doing!

### Full-Loot PvP
Risk vs reward in PvP zones. Yellow zones drop partial loot, Red zones drop everything.

### Deep Crafting
Create powerful gear and items through procedural crafting with material lore.

### Faction System
Join one of four world factions, gain standing, and unlock unique rewards.

### Season Challenges
Complete daily, weekly, and seasonal challenges for XP and rewards.

## Core Philosophy

Mortal Warcraft emphasizes:
- **Meaningful choices** - Every decision matters
- **Risk vs reward** - High risk, high reward gameplay
- **Player-driven economy** - Craft, trade, and compete
- **Horizontal progression** - Power through options, not raw stats

Good luck, and may the best survive!', 
'mechanics', 'getting-started,introduction,overview', 1, 'public', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

('combat-system', 'Combat System', 'Complete guide to Mortal Warcraft combat mechanics', '# Combat System

Mortal Warcraft features a **completely custom combat system** designed for skill-based, high-risk gameplay.

## Core Mechanics

### Brace Ability
- **Activation**: Press Brace key to reduce incoming damage
- **Effect**: Significant damage reduction for a short window
- **Cooldown**: Prevents spam, requires timing
- **Usage**: Essential for surviving dangerous encounters

### Hit/Miss System
- Based on **weapon skill** and **level difference**
- Higher skill = better hit chance
- Level gaps affect accuracy significantly
- No traditional hit rating - pure skill-based

### Critical Strikes
- Increased damage on critical hits
- Affected by stats and augments
- No traditional crit rating - dynamic calculation

### Custom Formulas
All damage, health, mana, and stats use **custom C++ formulas**:
- No reliance on traditional WoW stats
- Balanced for skill-based progression
- Tuned for full-loot risk/reward

## Risk Zones

### Green Zones
- **Safe** - No PvP allowed
- **No loot loss** on death
- Perfect for learning and crafting
- Towns and starting areas

### Yellow Zones
- **Partial PvP** - Friendly fire enabled
- **Partial loot drop** on death
- Keep: Chest, Mainhand, 1 Trinket, Mount Reins
- Lose: Everything else
- Moderate risk areas

### Red Zones
- **Full PvP** - Anything goes
- **Full loot drop** on death
- Keep: Nothing (except blessed items)
- High risk, high reward
- End-game content areas

## Crime System

### Notoriety
- Commit crimes to gain notoriety
- Visible to other players
- Affects NPC interactions
- Decays over time

### Outlaw Status
- Major crimes make you an outlaw
- Bounties can be placed
- Restricted from safe zones
- High-value target

### Bounties
- Players can place bounties on outlaws
- Bounty hunters can claim rewards
- Creates dynamic PvP content
- Risk vs reward gameplay', 
'mechanics', 'combat,pvp,risk-zones,crime', 1, 'public', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

('factions', 'Factions System', 'Guide to the four world factions', '# Factions

Mortal Warcraft features **four world factions** that players can pledge allegiance to.

## The Iron Ledger

**Theme**: Crafting Consortium & Trade Cartel

- **Focus**: Crafting, refining, logistics, trade
- **Likes**: Courier contracts, material transport, market activities
- **Dislikes**: Infrastructure destruction, excessive PvP near trade hubs
- **Rewards**: 
  - Unique crafting blueprints
  - Extra augment slots on gear
  - Reduced AH fees
  - Larger regional bank stash

## Order of the Shrine

**Theme**: Religious Order & Defense

- **Focus**: Defense, protection, healing, support
- **Likes**: Defending settlements, healing players, shrine activities
- **Dislikes**: Attacking protected areas, desecration
- **Rewards**:
  - Healing-focused abilities
  - Protection runes
  - Shrine bonuses
  - Support gear

## Black Sun Cartel

**Theme**: Criminal Organization & Black Market

- **Focus**: PvP, black market, smuggling, risk
- **Likes**: PvP activities, smuggling routes, black market trades
- **Dislikes**: Law enforcement, snitching
- **Rewards**:
  - PvP-focused gear
  - Smuggling routes
  - Black market access
  - Risk-taking bonuses

## Rangers'' Pact

**Theme**: Explorers & Scouts

- **Focus**: Exploration, gathering, scouting, discovery
- **Likes**: Exploring new areas, gathering resources, mapping
- **Dislikes**: Staying in one place, ignoring exploration
- **Rewards**:
  - Exploration tools
  - Gathering bonuses
  - Map enhancements
  - Discovery rewards

## Pledging

- **One faction at a time** - Choose your allegiance
- **Gain standing** through faction activities
- **Unlock rewards** as you progress
- **Switch factions** - Costs apply, but possible
- **Standing ranks**: Hated → Hostile → Unfriendly → Neutral → Friendly → Honored → Revered → Exalted', 
'mechanics', 'factions,pledging,reputation', 1, 'public', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

('lifeskills', 'Fishing & First Aid', 'Complete guide to lifeskills', '# Lifeskills: Fishing & First Aid

## Fishing

Fishing is a **gathering lifeskill** that provides essential resources.

### What You Get
- **Food components** for Cooking
- **Reagents** for Alchemy
- **Special bait** for anomalies and rifts
- **Economic value** through rare catches

### Skill Lines
- **Fishing: Coastal** - Lakes and seas near safe zones
- **Fishing: Inland** - Rivers, ponds, underground pools
- **Fishing: Deep Sea** - Open ocean, high-risk coasts
- **Fishing: Planar** - Late-game rifts and special locations

### Mechanics
- Equip fishing rod and bait
- Cast line at water source
- Wait for bite window (0.75-1.5s)
- Press interact to catch
- Skill affects catch quality and junk ratio

### Material Lore
- **Lore: Freshwater Fish** - Improves freshwater catches
- **Lore: Saltwater Fish** - Improves saltwater catches
- **Lore: Abyssal/Planar Fish** - Late-game planar fishing

## First Aid

First Aid is a **support lifeskill** for triage and debuff management.

### Skill Lines
- **Field Medicine** - General bandaging, out-of-combat healing
- **Trauma Care** - Combat dressings, fracture management
- **Toxicology** - Antidotes, poison/disease cures

### Items
- **Simple Bandage** - 15% HP restore, out of combat only
- **Combat Dressing** - Removes bleed, instant heal, usable in combat
- **Splint** - Removes movement debuffs
- **Antidote** - Removes poison and disease effects

### Philosophy
- **Not replacement healing** - Healer players still required
- **Triage support** - Manage debuffs and minor healing
- **Combat utility** - Some items usable in combat
- **Skill progression** - Higher skill = better items', 
'mechanics', 'fishing,first-aid,lifeskills', 1, 'public', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

('runes-augments', 'Runes & Augments', 'Complete guide to gear enhancement', '# Runes & Augments

Enhance your gear with **runes** and **augments** to customize your build.

## Runes

Runes grant **major abilities** to your gear pieces.

### Available Runes
- **Rune of Whirlwind** - Spin attack hitting nearby enemies
- **Rune of Blink** - Short-range teleport ability
- **Rune of Guard Counter** - Counter-attack after blocking (shield required)
- **Rune of Thorns** - Reflect damage to attackers (passive)

### Socketing
- **Weapons**: 1 rune slot
- **Armor**: 0-1 rune slots (chest, helm typically)
- **Accessories**: No rune slots

### Sources
- Dungeon/raid drops
- Public delves
- Faction vendors
- Rare crafting outputs

## Augments

Augments provide **smaller, tunable modifiers** to your gear.

### Categories
- **Offense** - Damage and crit modifiers
- **Defense** - Damage reduction and resistance
- **Utility** - Movement, capacity, quality of life

### Examples
- **Razor Gale** - Whirlwind applies bleed
- **Measured Strikes** - +5% crit when above 80% stamina
- **Executioner''s Edge** - +10% damage vs low-health enemies
- **Stone Brace** - Additional 10% damage reduction on Brace
- **Trailblazer** - Movement speed bonus in wilderness
- **Packrat** - +5% carry capacity for materials

### Socketing
- **Weapons**: 2-3 augment slots (3 for masterwork)
- **Armor**: 1-2 augment slots (2 for masterwork)
- **Accessories**: 1 augment slot

### Constraints
- Max total augments per item
- Per-type caps (e.g., max 1 offense on chest)
- Affinity requirements (some augments require specific gear types)

## Build Customization

- **Mix and match** runes and augments
- **Create unique builds** for different playstyles
- **Risk vs reward** - Enhanced gear is lost on death
- **Long-term progression** - Collect and experiment', 
'mechanics', 'runes,augments,gear,enhancements', 1, 'public', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

('season-challenges', 'Season Challenges', 'Guide to the seasonal challenge system', '# Season Challenges

Complete challenges to earn **XP and rewards** in the seasonal progression system.

## Challenge Types

### Daily Challenges
- **Reset**: Every 24 hours
- **Examples**: 
  - Kill 10 creatures
  - Gather 5 resources
  - Craft 3 items
  - Kill 1 player in PvP
  - Catch 5 fish
- **Rewards**: 100-150 XP per challenge

### Weekly Challenges
- **Reset**: Every 7 days
- **Examples**:
  - Complete 5 dungeon runs
  - Win 10 PvP matches
  - Complete 3 caravan contracts
  - Kill 1 raid boss
  - Gain 500 faction standing
- **Rewards**: 300-1000 XP per challenge

### Seasonal Challenges
- **Reset**: End of season
- **Examples**:
  - Kill 1000 creatures
  - Kill 100 players
  - Complete 50 dungeons
  - Craft 200 items
  - Reach Exalted with any faction
- **Rewards**: 2000-5000 XP per challenge

## Progression

### XP System
- Earn XP by completing challenges
- Progress through **ranks** (1-100+)
- Higher ranks unlock better rewards
- Seasonal reset at end of season

### Rewards
- **XP** - Primary progression currency
- **Currency** - PvP tokens, military credits
- **Items** - Unique seasonal rewards
- **Titles** - Seasonal achievement titles

## Tips

- **Focus on dailies** - Easy, consistent XP
- **Plan weeklies** - Higher rewards, more time
- **Track seasonals** - Long-term goals
- **Mix activities** - Variety keeps it fun', 
'mechanics', 'seasons,challenges,progression', 1, 'public', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

('build-presets', 'Build Presets', 'Save and load character builds', '# Build Presets

Save your character configuration and **swap between different builds** instantly.

## Preset Types

### PvP Presets
- Optimized for player vs player combat
- Focus on damage, survivability, PvP abilities
- Quick swap for arena or open world PvP

### PvE Presets
- Optimized for player vs environment
- Focus on damage, utility, group support
- Perfect for dungeons and raids

### Crafting Presets
- Optimized for gathering and crafting
- Focus on capacity, movement, utility
- Quick swap when gathering materials

## Features

### Save Current Build
- Capture current gear, stats, enhancements
- Name your preset
- Choose preset type
- Save for later use

### Load Preset
- Instantly swap to saved build
- Automatically equip gear
- Apply enhancements
- Update stats

### Manage Presets
- View all saved presets
- Delete unused presets
- Organize by type
- Quick access menu

## Usage Tips

- **Save before risky content** - Quick recovery build
- **Multiple PvP builds** - Different strategies
- **Crafting setup** - Dedicated gathering build
- **Experiment freely** - Easy to revert changes', 
'mechanics', 'builds,presets,loadouts', 1, 'public', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

('endless-contracts', 'Endless Contracts', 'Wave-based defense and survival content', '# Endless Contracts

Test your skills in **infinite wave-based content** with scaling difficulty.

## Contract Types

### Defense Contracts
- **Objective**: Defend your base against waves of enemies
- **Waves**: 1-50+ (scaling difficulty)
- **Rewards**: XP and gold per wave
- **Scaling**: Each wave harder than the last

### Survival Contracts
- **Objective**: Survive as long as possible in an arena
- **Waves**: 1-100+ (infinite scaling)
- **Rewards**: XP and gold per wave survived
- **Scaling**: Exponential difficulty increase

## Mechanics

### Wave Progression
- **Wave 1**: Basic enemies, easy difficulty
- **Wave 5**: Boss wave, increased difficulty
- **Wave 10**: Major boss wave, significant challenge
- **Wave 20+**: Elite waves, extreme difficulty

### Rewards
- **Base XP**: Per wave completed
- **Base Gold**: Per wave completed
- **Scaling Factor**: Increases with wave number
- **Bonus Rewards**: Special drops at milestone waves

### Failure
- **Death ends contract** - No partial rewards
- **Can restart** - Try again from wave 1
- **No penalty** - Safe to experiment

## Strategy

- **Prepare well** - Stock up on consumables
- **Know your limits** - Don''t push too hard
- **Team up** - Group contracts available
- **Learn patterns** - Each wave has patterns', 
'content', 'endless-contracts,defense,survival', 1, 'public', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP()),

('progression-system', 'Progression System', 'How leveling and skills work', '# Progression System

Mortal Warcraft uses a **completely custom progression system** based on skills, not traditional XP.

## Dynamic Level System

### How It Works
- Your **level is derived from skill points**
- Formula: `Level = Total Primary Skill Points / 48`
- No traditional XP grinding
- Progress through **doing**, not grinding

### Primary Skills
- **Combat Skills**: Weapon skills, combat abilities
- **Gathering Skills**: Mining, skinning, herbalism, fishing
- **Crafting Skills**: Blacksmithing, leatherworking, etc.
- **Lifeskills**: Fishing, First Aid

### Skill Advancement
- **Use skills** to gain points
- **Higher difficulty** = more skill gain
- **Diminishing returns** at high skill levels
- **Mastery trees** unlock at high levels

## Attribute System

### Stat Caps
- **Per-attribute cap**: 150 points
- **Total attribute cap**: 400 points across all attributes
- **Enforced automatically** - Cannot exceed caps
- **Balanced progression** - No stat inflation

### Attributes
- **Strength** - Melee damage, carry capacity
- **Agility** - Ranged damage, dodge chance
- **Intellect** - Spell damage, mana pool
- **Stamina** - Health pool, stamina pool
- **Spirit** - Mana regeneration, health regeneration

## Mastery Trees

### Warlord
- **Focus**: Combat and PvP
- **Unlocks**: Advanced combat abilities
- **Requirements**: High combat skill

### Guardian
- **Focus**: Defense and protection
- **Unlocks**: Defensive abilities
- **Requirements**: High defense skill

### Explorer
- **Focus**: Gathering and exploration
- **Unlocks**: Exploration bonuses
- **Requirements**: High gathering skill

## Long-Term Progression

- **Horizontal progression** - Power through options
- **Soft caps** - Diminishing returns prevent inflation
- **Gear tiers** - P1 through P6 progression
- **Content cadence** - Minor, Major, Epochal updates', 
'mechanics', 'progression,leveling,skills,attributes', 1, 'public', 1, 1, UNIX_TIMESTAMP(), UNIX_TIMESTAMP())

ON DUPLICATE KEY UPDATE 
    `content_markdown` = VALUES(`content_markdown`),
    `updated_at` = UNIX_TIMESTAMP();

-- For mortal_wiki_articles table (alternative schema)
INSERT INTO `mortal_wiki_articles` (`article_slug`, `title`, `content`, `category`, `tags`, `is_published`, `is_featured`, `created_at`, `last_edited_at`) 
SELECT 
    `slug` as article_slug,
    `title`,
    `content_markdown` as content,
    `category`,
    JSON_ARRAY(`tags`) as tags,
    `is_published`,
    0 as is_featured,
    `created_at`,
    `updated_at` as last_edited_at
FROM `wiki_pages`
WHERE `slug` IN ('welcome', 'combat-system', 'factions', 'lifeskills', 'runes-augments', 'season-challenges', 'build-presets', 'endless-contracts', 'progression-system')
ON DUPLICATE KEY UPDATE 
    `content` = VALUES(`content`),
    `last_edited_at` = UNIX_TIMESTAMP();

-- Summary
SELECT 
    'Wiki Articles Created' as summary,
    COUNT(*) as total_articles,
    COUNT(CASE WHEN is_published = 1 THEN 1 END) as published_articles
FROM wiki_pages
WHERE slug IN ('welcome', 'combat-system', 'factions', 'lifeskills', 'runes-augments', 'season-challenges', 'build-presets', 'endless-contracts', 'progression-system');

