#!/bin/bash
# Setup two branches: mortal-overhaul and realm2-era-progression

set -e

echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        🌿 Git Branch Setup 🌿                                 ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo ""

# Check if git is initialized
if [ ! -d .git ]; then
    echo "❌ Git repository not initialized. Run ./init-git-repo.sh first"
    exit 1
fi

# Get current branch
CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "master")

echo "📋 Current branch: ${CURRENT_BRANCH}"
echo ""

# Create mortal-overhaul branch (main development branch)
echo "🌿 Creating 'mortal-overhaul' branch..."
if git show-ref --verify --quiet refs/heads/mortal-overhaul; then
    echo "  Branch 'mortal-overhaul' already exists"
    git checkout mortal-overhaul 2>/dev/null || true
else
    git checkout -b mortal-overhaul
    echo "✅ Created and switched to 'mortal-overhaul' branch"
fi

# Commit current changes to mortal-overhaul
if [ -n "$(git status --porcelain)" ]; then
    echo ""
    echo "💾 Committing current changes to mortal-overhaul branch..."
    git add -A
    git commit -m "feat: Initial commit - Mortal Overhaul realm

- Docker deployment setup
- GPU server deployment scripts
- Module source code
- Documentation and guides
- Configuration files"
    echo "✅ Changes committed to mortal-overhaul"
fi

# Create realm2-era-progression branch
echo ""
echo "🌿 Creating 'realm2-era-progression' branch..."
if git show-ref --verify --quiet refs/heads/realm2-era-progression; then
    echo "  Branch 'realm2-era-progression' already exists"
    git checkout realm2-era-progression 2>/dev/null || true
else
    git checkout -b realm2-era-progression
    echo "✅ Created and switched to 'realm2-era-progression' branch"
fi

# Add realm2-specific files if they exist
if [ -d "realm2" ]; then
    echo ""
    echo "📦 Adding realm2-specific files..."
    git add realm2/ 2>/dev/null || true
    
    if [ -n "$(git status --porcelain realm2/ 2>/dev/null)" ]; then
        git commit -m "feat: Realm2 Era Progression setup

- Realm2 AzerothCore configuration
- Era progression module
- Realm2-specific scripts and configs"
        echo "✅ Realm2 files committed"
    else
        echo "  No new realm2 files to commit"
    fi
fi

# Create branch switching helper script
echo ""
echo "📝 Creating branch switching helper..."
cat > switch-realm.sh << 'EOF'
#!/bin/bash
# Quick script to switch between realm branches

case "$1" in
    mortal|mortal-overhaul)
        echo "🌿 Switching to mortal-overhaul branch..."
        git checkout mortal-overhaul
        echo "✅ Switched to mortal-overhaul (Mortal Warcraft realm)"
        ;;
    realm2|era|progression)
        echo "🌿 Switching to realm2-era-progression branch..."
        git checkout realm2-era-progression
        echo "✅ Switched to realm2-era-progression (Era Progression realm)"
        ;;
    *)
        echo "Usage: ./switch-realm.sh {mortal|realm2}"
        echo ""
        echo "Branches:"
        echo "  mortal  - Mortal Overhaul realm (main development)"
        echo "  realm2  - Realm2 Era Progression realm"
        echo ""
        echo "Current branch: $(git branch --show-current)"
        exit 1
        ;;
esac
EOF
chmod +x switch-realm.sh
echo "✅ Created switch-realm.sh helper script"

# Create branch documentation
echo ""
echo "📚 Creating branch documentation..."
cat > BRANCH_STRATEGY.md << 'EOF'
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

## Branch Protection

Consider setting up branch protection rules:
- Require pull requests for main branches
- Require status checks
- Require reviews for critical changes

## Current Branch

Check current branch:
```bash
git branch --show-current
```

List all branches:
```bash
git branch -a
```
EOF
echo "✅ Created BRANCH_STRATEGY.md"

# Show final status
echo ""
echo "╔═══════════════════════════════════════════════════════════════╗"
echo "║        ✅ Branch Setup Complete! ✅                          ║"
echo "╠═══════════════════════════════════════════════════════════════╣"
echo ""
echo "📋 Branches created:"
git branch -a
echo ""
echo "🌿 Current branch: $(git branch --show-current)"
echo ""
echo "📚 Documentation:"
echo "  • BRANCH_STRATEGY.md - Branch usage guide"
echo ""
echo "🚀 Quick Commands:"
echo "  • Switch to Mortal Overhaul: ./switch-realm.sh mortal"
echo "  • Switch to Realm2: ./switch-realm.sh realm2"
echo "  • View branches: git branch -a"
echo ""
echo "╚═══════════════════════════════════════════════════════════════╝"

