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

