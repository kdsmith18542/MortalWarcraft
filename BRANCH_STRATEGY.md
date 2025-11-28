# Git Branch Strategy

This repository uses two main branches for different server realms:

## Branches

### `mortal-overhaul` (Main Development)
**Purpose**: Mortal Warcraft custom server with survival mechanics

**Contains**:
- Mortal Overhaul module (`azerothcore/modules/mortal_overhaul/`)
- Custom skill system
- Procedural crafting
- Faction-based PvP
- Survival mechanics
- Custom UI and addons

**Default branch for**: Main Mortal Warcraft development

### `realm2-era-progression`
**Purpose**: Classic Era progression server

**Contains**:
- Realm2 AzerothCore setup (`realm2/azerothcore/`)
- Era progression module
- Classic content progression
- Realm2-specific configurations

**Default branch for**: Era progression server development

## Usage

### Switch Between Branches

```bash
# Switch to Mortal Overhaul
./switch-realm.sh mortal
# or
git checkout mortal-overhaul

# Switch to Realm2 Era Progression
./switch-realm.sh realm2
# or
git checkout realm2-era-progression
```

### Development Workflow

1. **For Mortal Overhaul development**:
   ```bash
   git checkout mortal-overhaul
   # Make changes
   git add .
   git commit -m "feat: Description"
   git push origin mortal-overhaul
   ```

2. **For Realm2 development**:
   ```bash
   git checkout realm2-era-progression
   # Make changes
   git add .
   git commit -m "feat: Description"
   git push origin realm2-era-progression
   ```

### Merging Common Changes

If you need to share changes between branches (e.g., Docker setup, documentation):

```bash
# From mortal-overhaul branch
git checkout mortal-overhaul
# Make common changes
git commit -m "docs: Update Docker guide"

# Merge to realm2
git checkout realm2-era-progression
git merge mortal-overhaul --no-ff -m "Merge common Docker updates from mortal-overhaul"
```

## Current Branch

Check current branch:
```bash
git branch --show-current
```

List all branches:
```bash
git branch -a
```
