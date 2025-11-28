#!/bin/bash
# Systematic Spec Implementation Audit
# Checks for missing: Event Hooks, Game World Integration, UI

SPEC_DIR="docs/specs"
LUA_DIR="lua"
SQL_DIR="sql"
ADDONS_DIR="addons/MortalUI"

echo "=== SYSTEMATIC SPEC IMPLEMENTATION AUDIT ==="
echo ""
echo "Checking for missing patterns:"
echo "  1. Event hooks (RegisterPlayerEvent, RegisterCreatureEvent, etc.)"
echo "  2. Game world integration (NPC gossip, item usage, GameObject interaction)"
echo "  3. UI components (MortalUI modules, AIO handlers)"
echo ""

# Function to check if spec has implementation
check_spec() {
    local spec_file="$1"
    local spec_name=$(basename "$spec_file" .md)
    
    echo "---"
    echo "SPEC: $spec_name"
    echo ""
    
    # Check for database tables
    local tables_found=$(grep -h "CREATE TABLE\|INSERT INTO" "$SQL_DIR"/*.sql 2>/dev/null | grep -i "$spec_name\|mortal_" | wc -l)
    echo "  Database: $tables_found table references"
    
    # Check for Lua files
    local lua_files=$(find "$LUA_DIR" -name "*${spec_name}*" -o -name "*$(echo $spec_name | tr '-' '_')*" 2>/dev/null | wc -l)
    echo "  Lua Files: $lua_files files"
    
    # Check for event hooks in Lua
    local event_hooks=$(grep -r "RegisterPlayerEvent\|RegisterCreatureEvent\|RegisterGameObjectEvent\|RegisterItemEvent" "$LUA_DIR"/*.lua 2>/dev/null | grep -i "$spec_name\|$(echo $spec_name | tr '-' '_')" | wc -l)
    echo "  Event Hooks: $event_hooks hooks"
    
    # Check for NPC/Item/GameObject integration
    local npc_integration=$(grep -r "gossip\|OnGossip\|SendGossipMenu" "$LUA_DIR"/*.lua 2>/dev/null | grep -i "$spec_name\|$(echo $spec_name | tr '-' '_')" | wc -l)
    local item_integration=$(grep -r "OnUseItem\|UseItem" "$LUA_DIR"/*.lua 2>/dev/null | grep -i "$spec_name\|$(echo $spec_name | tr '-' '_')" | wc -l)
    local go_integration=$(grep -r "OnGameObjectUse\|GameObject" "$LUA_DIR"/*.lua 2>/dev/null | grep -i "$spec_name\|$(echo $spec_name | tr '-' '_')" | wc -l)
    echo "  NPC Integration: $npc_integration references"
    echo "  Item Integration: $item_integration references"
    echo "  GameObject Integration: $go_integration references"
    
    # Check for UI components
    local ui_files=$(find "$ADDONS_DIR" -name "*${spec_name}*" -o -name "*$(echo $spec_name | tr '-' '_')*" 2>/dev/null | wc -l)
    local aio_handlers=$(find "$LUA_DIR/aio" -name "*${spec_name}*" -o -name "*$(echo $spec_name | tr '-' '_')*" 2>/dev/null | wc -l)
    echo "  UI Modules: $ui_files files"
    echo "  AIO Handlers: $aio_handlers files"
    
    # Determine status
    if [ "$event_hooks" -eq 0 ] && [ "$npc_integration" -eq 0 ] && [ "$item_integration" -eq 0 ] && [ "$go_integration" -eq 0 ]; then
        echo "  STATUS: ❌ NO INTEGRATION"
    elif [ "$event_hooks" -eq 0 ]; then
        echo "  STATUS: ⚠️  MISSING EVENT HOOKS"
    elif [ "$ui_files" -eq 0 ] && [ "$aio_handlers" -eq 0 ]; then
        echo "  STATUS: ⚠️  MISSING UI"
    else
        echo "  STATUS: ✅ HAS INTEGRATION"
    fi
    echo ""
}

# Process specs in batches of 3
specs=($(ls -1 "$SPEC_DIR"/*.md | sort))
total=${#specs[@]}
batch_size=3

for ((i=0; i<total; i+=batch_size)); do
    echo "=== BATCH $((i/batch_size + 1)) ==="
    echo ""
    
    for ((j=i; j<i+batch_size && j<total; j++)); do
        check_spec "${specs[j]}"
    done
    
    echo ""
done

echo "=== AUDIT COMPLETE ==="

