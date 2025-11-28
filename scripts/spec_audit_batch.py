#!/usr/bin/env python3
"""
Systematic Spec Implementation Audit
Checks for missing: Event Hooks, Game World Integration, UI
Processes 3 specs at a time
"""

import os
import re
import subprocess
from pathlib import Path

SPEC_DIR = Path("docs/specs")
LUA_DIR = Path("lua")
SQL_DIR = Path("sql")
ADDONS_DIR = Path("addons/MortalUI")

def count_matches(pattern, files, case_insensitive=True):
    """Count matches of pattern in files using ripgrep"""
    flags = "-i" if case_insensitive else ""
    try:
        result = subprocess.run(
            ["rg", flags, pattern] + [str(f) for f in files],
            capture_output=True,
            text=True
        )
        return len(result.stdout.strip().split('\n')) if result.stdout.strip() else 0
    except:
        return 0

def check_spec_implementation(spec_file):
    """Check implementation status for a spec"""
    spec_name = spec_file.stem
    spec_keywords = spec_name.replace("-", "_").replace("_", "|")
    
    results = {
        "spec": spec_name,
        "database": 0,
        "lua_files": 0,
        "event_hooks": 0,
        "npc_integration": 0,
        "item_integration": 0,
        "go_integration": 0,
        "ui_modules": 0,
        "aio_handlers": 0,
        "status": "UNKNOWN"
    }
    
    # Check database tables
    sql_files = list(SQL_DIR.glob("*.sql"))
    if sql_files:
        results["database"] = count_matches(
            f"CREATE TABLE.*{spec_keywords}|INSERT INTO.*{spec_keywords}|mortal_.*{spec_keywords}",
            sql_files
        )
    
    # Check Lua files
    lua_files = list(LUA_DIR.glob("*.lua"))
    spec_lua_files = [f for f in lua_files if spec_keywords.replace("|", "_") in f.stem.lower()]
    results["lua_files"] = len(spec_lua_files)
    
    # Check event hooks
    if lua_files:
        results["event_hooks"] = count_matches(
            f"RegisterPlayerEvent|RegisterCreatureEvent|RegisterGameObjectEvent|RegisterItemEvent",
            [f for f in lua_files if any(kw in f.stem.lower() for kw in spec_keywords.split("|"))]
        )
    
    # Check NPC integration
    if lua_files:
        results["npc_integration"] = count_matches(
            f"OnGossip|SendGossipMenu|gossip",
            lua_files
        )
    
    # Check item integration
    if lua_files:
        results["item_integration"] = count_matches(
            f"OnUseItem|UseItem",
            lua_files
        )
    
    # Check GameObject integration
    if lua_files:
        results["go_integration"] = count_matches(
            f"OnGameObjectUse|GameObject",
            lua_files
        )
    
    # Check UI modules
    if ADDONS_DIR.exists():
        ui_files = list(ADDONS_DIR.rglob("*.lua"))
        results["ui_modules"] = len([f for f in ui_files if any(kw in f.stem.lower() for kw in spec_keywords.split("|"))])
    
    # Check AIO handlers
    aio_dir = LUA_DIR / "aio"
    if aio_dir.exists():
        aio_files = list(aio_dir.glob("*.lua"))
        results["aio_handlers"] = len([f for f in aio_files if any(kw in f.stem.lower() for kw in spec_keywords.split("|"))])
    
    # Determine status
    if results["event_hooks"] == 0 and results["npc_integration"] == 0 and results["item_integration"] == 0:
        results["status"] = "❌ NO INTEGRATION"
    elif results["event_hooks"] == 0:
        results["status"] = "⚠️  MISSING EVENT HOOKS"
    elif results["ui_modules"] == 0 and results["aio_handlers"] == 0:
        results["status"] = "⚠️  MISSING UI"
    else:
        results["status"] = "✅ HAS INTEGRATION"
    
    return results

def main():
    print("=== SYSTEMATIC SPEC IMPLEMENTATION AUDIT ===")
    print("")
    print("Checking for missing patterns:")
    print("  1. Event hooks (RegisterPlayerEvent, RegisterCreatureEvent, etc.)")
    print("  2. Game world integration (NPC gossip, item usage, GameObject interaction)")
    print("  3. UI components (MortalUI modules, AIO handlers)")
    print("")
    
    # Get all spec files
    spec_files = sorted(SPEC_DIR.glob("*.md"))
    total = len(spec_files)
    batch_size = 3
    
    all_results = []
    
    # Process in batches
    for i in range(0, total, batch_size):
        batch_num = (i // batch_size) + 1
        batch = spec_files[i:i+batch_size]
        
        print(f"=== BATCH {batch_num}: Specs {i+1}-{min(i+batch_size, total)} ===")
        print("")
        
        for spec_file in batch:
            results = check_spec_implementation(spec_file)
            all_results.append(results)
            
            print(f"SPEC: {results['spec']}")
            print(f"  Database: {results['database']} references")
            print(f"  Lua Files: {results['lua_files']} files")
            print(f"  Event Hooks: {results['event_hooks']} hooks")
            print(f"  NPC Integration: {results['npc_integration']} references")
            print(f"  Item Integration: {results['item_integration']} references")
            print(f"  GameObject Integration: {results['go_integration']} references")
            print(f"  UI Modules: {results['ui_modules']} files")
            print(f"  AIO Handlers: {results['aio_handlers']} files")
            print(f"  STATUS: {results['status']}")
            print("")
        
        print("")
    
    # Summary
    print("=== SUMMARY ===")
    print("")
    no_integration = [r for r in all_results if "NO INTEGRATION" in r["status"]]
    missing_hooks = [r for r in all_results if "MISSING EVENT HOOKS" in r["status"]]
    missing_ui = [r for r in all_results if "MISSING UI" in r["status"]]
    has_integration = [r for r in all_results if "HAS INTEGRATION" in r["status"]]
    
    print(f"Total Specs: {len(all_results)}")
    print(f"❌ No Integration: {len(no_integration)}")
    print(f"⚠️  Missing Event Hooks: {len(missing_hooks)}")
    print(f"⚠️  Missing UI: {len(missing_ui)}")
    print(f"✅ Has Integration: {len(has_integration)}")
    print("")
    
    if no_integration:
        print("Specs with NO INTEGRATION:")
        for r in no_integration:
            print(f"  - {r['spec']}")
        print("")
    
    if missing_hooks:
        print("Specs MISSING EVENT HOOKS:")
        for r in missing_hooks:
            print(f"  - {r['spec']}")
        print("")
    
    if missing_ui:
        print("Specs MISSING UI:")
        for r in missing_ui:
            print(f"  - {r['spec']}")

if __name__ == "__main__":
    main()

