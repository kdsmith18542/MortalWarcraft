#!/bin/bash
# Systematic Audit of ALL Specs
# Checks for: Event Hooks, NPC/Item/GO Integration, UI

SPEC_DIR="docs/specs"
LUA_DIR="lua"
ADDONS_DIR="addons/MortalUI"
AIO_DIR="lua/aio"

echo "=== SYSTEMATIC AUDIT: ALL SPECS ==="
echo "Checking for missing: Event Hooks, Integration, UI"
echo ""

declare -a no_hooks
declare -a no_integration
declare -a no_ui
declare -a has_all

for spec_file in "$SPEC_DIR"/*.md; do
    spec_name=$(basename "$spec_file" .md)
    
    # Find related Lua files (by name matching)
    lua_files=$(find "$LUA_DIR" -name "*.lua" -type f | xargs grep -l "$spec_name\|$(echo $spec_name | tr '-' '_')" 2>/dev/null | head -10)
    lua_count=$(echo "$lua_files" | grep -v "^$" | wc -l)
    
    if [ "$lua_count" -eq 0 ]; then
        continue  # Skip specs with no Lua files
    fi
    
    # Count event hooks
    hook_count=0
    if [ -n "$lua_files" ]; then
        hook_count=$(grep -h "RegisterPlayerEvent\|RegisterCreatureEvent\|RegisterGameObjectEvent\|RegisterItemEvent" $lua_files 2>/dev/null | wc -l)
    fi
    
    # Count integration
    npc_count=$(grep -h "OnGossip\|SendGossipMenu" $lua_files 2>/dev/null | wc -l)
    item_count=$(grep -h "OnUseItem\|RegisterItemEvent" $lua_files 2>/dev/null | wc -l)
    go_count=$(grep -h "OnGameObjectUse\|RegisterGameObjectEvent" $lua_files 2>/dev/null | wc -l)
    integration_count=$((npc_count + item_count + go_count))
    
    # Count UI
    ui_count=$(find "$ADDONS_DIR" -name "*${spec_name}*" -o -name "*$(echo $spec_name | tr '-' '_')*" 2>/dev/null | wc -l)
    aio_count=$(find "$AIO_DIR" -name "*${spec_name}*" -o -name "*$(echo $spec_name | tr '-' '_')*" 2>/dev/null | wc -l)
    ui_total=$((ui_count + aio_count))
    
    # Classify
    if [ "$hook_count" -eq 0 ] && [ "$integration_count" -eq 0 ]; then
        no_integration+=("$spec_name")
        echo "❌ $spec_name: NO INTEGRATION (Lua: $lua_count, Hooks: 0, Integration: 0, UI: $ui_total)"
    elif [ "$hook_count" -eq 0 ]; then
        no_hooks+=("$spec_name")
        echo "⚠️  $spec_name: MISSING HOOKS (Lua: $lua_count, Hooks: 0, Integration: $integration_count, UI: $ui_total)"
    elif [ "$ui_total" -eq 0 ]; then
        no_ui+=("$spec_name")
        echo "⚠️  $spec_name: MISSING UI (Lua: $lua_count, Hooks: $hook_count, Integration: $integration_count, UI: 0)"
    else
        has_all+=("$spec_name")
        echo "✅ $spec_name: HAS INTEGRATION (Lua: $lua_count, Hooks: $hook_count, Integration: $integration_count, UI: $ui_total)"
    fi
done

echo ""
echo "=== SUMMARY ==="
echo "❌ No Integration: ${#no_integration[@]}"
echo "⚠️  Missing Event Hooks: ${#no_hooks[@]}"
echo "⚠️  Missing UI: ${#no_ui[@]}"
echo "✅ Has Integration: ${#has_all[@]}"

