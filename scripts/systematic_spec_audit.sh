#!/bin/bash
# Systematic Spec Audit - Checks for missing Event Hooks, Integration, UI
# Processes all specs and identifies missing patterns

SPEC_DIR="docs/specs"
LUA_DIR="lua"
ADDONS_DIR="addons/MortalUI"
AIO_DIR="lua/aio"

echo "=== SYSTEMATIC SPEC IMPLEMENTATION AUDIT ==="
echo ""
echo "Checking for missing patterns:"
echo "  1. Event hooks (RegisterPlayerEvent, etc.)"
echo "  2. Game world integration (NPC gossip, item usage)"
echo "  3. UI components (MortalUI modules, AIO handlers)"
echo ""

# Arrays to track results
declare -a no_integration
declare -a missing_hooks
declare -a missing_ui
declare -a has_integration

# Process each spec
for spec_file in "$SPEC_DIR"/*.md; do
    spec_name=$(basename "$spec_file" .md)
    spec_key=$(echo "$spec_name" | tr '-' '_')
    
    # Find related Lua files
    lua_files=$(find "$LUA_DIR" -name "*${spec_name}*" -o -name "*${spec_key}*" 2>/dev/null)
    lua_count=$(echo "$lua_files" | grep -v "^$" | wc -l)
    
    # Count event hooks
    hook_count=0
    if [ "$lua_count" -gt 0 ]; then
        hook_count=$(grep -h "RegisterPlayerEvent\|RegisterCreatureEvent\|RegisterGameObjectEvent\|RegisterItemEvent" $lua_files 2>/dev/null | wc -l)
    fi
    
    # Count NPC/Item/GO integration
    npc_count=$(grep -h "OnGossip\|SendGossipMenu" $lua_files 2>/dev/null | wc -l)
    item_count=$(grep -h "OnUseItem\|UseItem" $lua_files 2>/dev/null | wc -l)
    go_count=$(grep -h "OnGameObjectUse\|GameObject" $lua_files 2>/dev/null | wc -l)
    integration_count=$((npc_count + item_count + go_count))
    
    # Count UI components
    ui_count=$(find "$ADDONS_DIR" -name "*${spec_name}*" -o -name "*${spec_key}*" 2>/dev/null | wc -l)
    aio_count=$(find "$AIO_DIR" -name "*${spec_name}*" -o -name "*${spec_key}*" 2>/dev/null | wc -l)
    ui_total=$((ui_count + aio_count))
    
    # Classify status
    if [ "$lua_count" -eq 0 ]; then
        # No Lua files at all - skip or mark as not started
        continue
    elif [ "$hook_count" -eq 0 ] && [ "$integration_count" -eq 0 ]; then
        no_integration+=("$spec_name")
        echo "❌ $spec_name: NO INTEGRATION (Lua: $lua_count, Hooks: 0, Integration: 0, UI: $ui_total)"
    elif [ "$hook_count" -eq 0 ]; then
        missing_hooks+=("$spec_name")
        echo "⚠️  $spec_name: MISSING EVENT HOOKS (Lua: $lua_count, Hooks: 0, Integration: $integration_count, UI: $ui_total)"
    elif [ "$ui_total" -eq 0 ]; then
        missing_ui+=("$spec_name")
        echo "⚠️  $spec_name: MISSING UI (Lua: $lua_count, Hooks: $hook_count, Integration: $integration_count, UI: 0)"
    else
        has_integration+=("$spec_name")
        echo "✅ $spec_name: HAS INTEGRATION (Lua: $lua_count, Hooks: $hook_count, Integration: $integration_count, UI: $ui_total)"
    fi
done

echo ""
echo "=== SUMMARY ==="
echo ""
echo "Total Specs Checked: $(ls -1 "$SPEC_DIR"/*.md | wc -l)"
echo "❌ No Integration: ${#no_integration[@]}"
echo "⚠️  Missing Event Hooks: ${#missing_hooks[@]}"
echo "⚠️  Missing UI: ${#missing_ui[@]}"
echo "✅ Has Integration: ${#has_integration[@]}"
echo ""

if [ ${#no_integration[@]} -gt 0 ]; then
    echo "Specs with NO INTEGRATION:"
    for spec in "${no_integration[@]}"; do
        echo "  - $spec"
    done
    echo ""
fi

if [ ${#missing_hooks[@]} -gt 0 ]; then
    echo "Specs MISSING EVENT HOOKS:"
    for spec in "${missing_hooks[@]}"; do
        echo "  - $spec"
    done
    echo ""
fi

if [ ${#missing_ui[@]} -gt 0 ]; then
    echo "Specs MISSING UI:"
    for spec in "${missing_ui[@]}"; do
        echo "  - $spec"
    done
    echo ""
fi

