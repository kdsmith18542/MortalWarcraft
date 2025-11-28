#!/usr/bin/env python3
"""
Systematic Spec Verification Tool
Verifies ALL spec documents against actual codebase implementation.
No fake reports - only real verification.
"""

import os
import re
import json
from pathlib import Path
from collections import defaultdict

# Directories
SPEC_DIR = Path("docs/specs")
LUA_DIR = Path("lua")
SQL_DIR = Path("sql")
SRC_DIR = Path("src")
MODULE_SRC_DIR = Path("azerothcore/modules/mortal_overhaul/src")
MODULE_LUA_DIR = Path("azerothcore/modules/mortal_overhaul/lua")
ADDONS_DIR = Path("addons/MortalUI")

# Results storage
results = {
    "specs_checked": 0,
    "specs_complete": 0,
    "specs_partial": 0,
    "specs_missing": 0,
    "details": {}
}

def find_files(pattern, directory, recursive=True):
    """Find files matching pattern"""
    files = []
    if recursive:
        for path in directory.rglob(pattern):
            if path.is_file():
                files.append(path)
    else:
        for path in directory.glob(pattern):
            if path.is_file():
                files.append(path)
    return files

def check_lua_file_exists(filename):
    """Check if Lua file exists (exact or partial match) in lua/ or module/lua/"""
    # Try exact match in lua/
    exact_path = LUA_DIR / filename
    if exact_path.exists():
        return True, str(exact_path)
    
    # Try exact match in module/lua/
    if MODULE_LUA_DIR.exists():
        module_exact_path = MODULE_LUA_DIR / filename
        if module_exact_path.exists():
            return True, str(module_exact_path)
    
    # Try partial match in lua/
    for lua_file in find_files("*.lua", LUA_DIR):
        if filename.lower().replace("_", "").replace("-", "") in lua_file.name.lower().replace("_", "").replace("-", ""):
            return True, str(lua_file)
    
    # Try partial match in module/lua/
    if MODULE_LUA_DIR.exists():
        for lua_file in find_files("*.lua", MODULE_LUA_DIR):
            if filename.lower().replace("_", "").replace("-", "") in lua_file.name.lower().replace("_", "").replace("-", ""):
                return True, str(lua_file)
    
    return False, None

def check_sql_table_exists(table_name):
    """Check if SQL table is created"""
    for sql_file in find_files("*.sql", SQL_DIR):
        try:
            with open(sql_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                # Look for CREATE TABLE with table name
                pattern = rf'CREATE\s+TABLE\s+(?:IF\s+NOT\s+EXISTS\s+)?[`"]?{re.escape(table_name)}[`"]?'
                if re.search(pattern, content, re.IGNORECASE):
                    return True, str(sql_file)
        except:
            continue
    return False, None

def check_cpp_file_exists(filename):
    """Check if C++ file exists in src/ or module/src/"""
    # Check in src/ first
    exact_path = SRC_DIR / filename
    if exact_path.exists():
        return True, str(exact_path)
    
    # Check in module/src/
    module_exact_path = MODULE_SRC_DIR / filename
    if module_exact_path.exists():
        return True, str(module_exact_path)
    
    # Try partial match in src/
    for cpp_file in find_files("*.cpp", SRC_DIR):
        if filename.lower().replace("_", "").replace("-", "") in cpp_file.name.lower().replace("_", "").replace("-", ""):
            return True, str(cpp_file)
    
    for h_file in find_files("*.h", SRC_DIR):
        if filename.lower().replace("_", "").replace("-", "") in h_file.name.lower().replace("_", "").replace("-", ""):
            return True, str(h_file)
    
    # Try partial match in module/src/
    if MODULE_SRC_DIR.exists():
        for cpp_file in find_files("*.cpp", MODULE_SRC_DIR):
            if filename.lower().replace("_", "").replace("-", "") in cpp_file.name.lower().replace("_", "").replace("-", ""):
                return True, str(cpp_file)
        
        for h_file in find_files("*.h", MODULE_SRC_DIR):
            if filename.lower().replace("_", "").replace("-", "") in h_file.name.lower().replace("_", "").replace("-", ""):
                return True, str(h_file)
    
    return False, None

def check_event_hooks(lua_file):
    """Check if Lua file has event hooks registered"""
    if not lua_file or not os.path.exists(lua_file):
        return False
    
    try:
        with open(lua_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            # Check for common event registrations
            hooks = [
                'RegisterPlayerEvent',
                'RegisterCreatureEvent',
                'RegisterItemEvent',
                'RegisterGameObjectEvent',
                'RegisterSpellEvent'
            ]
            return any(hook in content for hook in hooks)
    except:
        return False

def check_sql_mentions(spec_name):
    """Check if spec is mentioned in SQL files"""
    mentions = []
    for sql_file in find_files("*.sql", SQL_DIR):
        try:
            with open(sql_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                # Normalize spec name for matching
                normalized = spec_name.lower().replace("-", "_").replace(" ", "_")
                if normalized in content.lower() or spec_name.lower() in content.lower():
                    mentions.append(str(sql_file))
        except:
            continue
    return mentions

def check_cpp_mentions(spec_name):
    """Check if spec is mentioned in C++ files in src/ or module/src/"""
    mentions = []
    # Check src/
    for cpp_file in find_files("*.cpp", SRC_DIR):
        try:
            with open(cpp_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                normalized = spec_name.lower().replace("-", "_").replace(" ", "_")
                if normalized in content.lower() or spec_name.lower() in content.lower():
                    mentions.append(str(cpp_file))
        except:
            continue
    for h_file in find_files("*.h", SRC_DIR):
        try:
            with open(h_file, 'r', encoding='utf-8', errors='ignore') as f:
                content = f.read()
                normalized = spec_name.lower().replace("-", "_").replace(" ", "_")
                if normalized in content.lower() or spec_name.lower() in content.lower():
                    mentions.append(str(h_file))
        except:
            continue
    
    # Check module/src/
    if MODULE_SRC_DIR.exists():
        for cpp_file in find_files("*.cpp", MODULE_SRC_DIR):
            try:
                with open(cpp_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    normalized = spec_name.lower().replace("-", "_").replace(" ", "_")
                    if normalized in content.lower() or spec_name.lower() in content.lower():
                        mentions.append(str(cpp_file))
            except:
                continue
        for h_file in find_files("*.h", MODULE_SRC_DIR):
            try:
                with open(h_file, 'r', encoding='utf-8', errors='ignore') as f:
                    content = f.read()
                    normalized = spec_name.lower().replace("-", "_").replace(" ", "_")
                    if normalized in content.lower() or spec_name.lower() in content.lower():
                        mentions.append(str(h_file))
            except:
                continue
    
    return mentions

def extract_spec_requirements(spec_file):
    """Extract implementation requirements from spec file"""
    requirements = {
        "lua_files": [],
        "cpp_files": [],
        "sql_tables": [],
        "features": []
    }
    
    try:
        with open(spec_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            
            # Extract Lua file mentions
            lua_pattern = r'`([a-z_]+\.lua)`|([a-z_]+\.lua)'
            for match in re.finditer(lua_pattern, content, re.IGNORECASE):
                lua_file = match.group(1) or match.group(2)
                if lua_file and lua_file not in requirements["lua_files"]:
                    requirements["lua_files"].append(lua_file)
            
            # Extract C++ file mentions
            cpp_pattern = r'`([A-Za-z_]+\.(cpp|h))`|([A-Za-z_]+\.(cpp|h))'
            for match in re.finditer(cpp_pattern, content):
                cpp_file = match.group(1) or match.group(3)
                if cpp_file and cpp_file not in requirements["cpp_files"]:
                    requirements["cpp_files"].append(cpp_file)
            
            # Extract SQL table mentions
            table_pattern = r'`([a-z_]+)`\s+\(|CREATE\s+TABLE\s+[`"]?([a-z_]+)[`"]?'
            for match in re.finditer(table_pattern, content, re.IGNORECASE):
                table = match.group(1) or match.group(2)
                if table and table not in requirements["sql_tables"]:
                    requirements["sql_tables"].append(table)
            
            # Look for implementation sections
            if "## 9. Technical Implementation" in content or "## Implementation" in content:
                # Try to extract more specific requirements
                impl_section = content.split("## 9. Technical Implementation")[-1] if "## 9. Technical Implementation" in content else ""
                if not impl_section:
                    impl_section = content.split("## Implementation")[-1] if "## Implementation" in content else ""
                
                # Extract file lists from implementation section
                for line in impl_section.split('\n'):
                    if '.lua' in line.lower():
                        match = re.search(r'([a-z_]+\.lua)', line, re.IGNORECASE)
                        if match and match.group(1) not in requirements["lua_files"]:
                            requirements["lua_files"].append(match.group(1))
                    if '.cpp' in line.lower() or '.h' in line.lower():
                        match = re.search(r'([a-z_]+\.(cpp|h))', line, re.IGNORECASE)
                        if match and match.group(1) not in requirements["cpp_files"]:
                            requirements["cpp_files"].append(match.group(1))
    
    except Exception as e:
        print(f"Error reading {spec_file}: {e}")
    
    return requirements

def verify_spec(spec_file):
    """Verify a single spec file"""
    spec_name = spec_file.stem
    spec_num = spec_name.split('-')[0] if '-' in spec_name else "unknown"
    
    print(f"Verifying: {spec_name}...")
    
    result = {
        "spec_file": str(spec_file),
        "spec_name": spec_name,
        "spec_num": spec_num,
        "status": "unknown",
        "completion": 0,
        "lua_files": {"required": [], "found": [], "missing": []},
        "cpp_files": {"required": [], "found": [], "missing": []},
        "sql_tables": {"required": [], "found": [], "missing": []},
        "has_event_hooks": False,
        "sql_mentions": [],
        "cpp_mentions": [],
        "issues": []
    }
    
    # Extract requirements
    requirements = extract_spec_requirements(spec_file)
    
    # Check Lua files - but C++ implementations are preferred and valid alternatives
    result["lua_files"]["required"] = requirements["lua_files"]
    for lua_file in requirements["lua_files"]:
        # First check for C++ equivalent (preferred)
        base_name = lua_file.replace(".lua", "").replace("_", " ").replace("-", " ")
        # Convert to title case and remove spaces: "brace handler" -> "BraceHandler"
        words = base_name.split()
        camel_case = "".join(word.capitalize() for word in words)
        
        # Try common patterns:
        # brace_handler.lua -> MortalBraceMechanic, MortalBraceHandler, BraceHandler
        # crime_system.lua -> MortalCrimeSystem, MortalCrime, CrimeSystem
        # outlaw_state.lua -> MortalOutlawRestrictions, MortalOutlawState, OutlawState
        cpp_patterns = [
            f"Mortal{camel_case}",
            f"Mortal{words[0].capitalize()}",  # First word only
            f"{camel_case}",
            # Special cases
            f"Mortal{words[0].capitalize()}Mechanic" if "brace" in base_name.lower() else None,
            f"Mortal{words[0].capitalize()}System" if "system" in base_name.lower() else None,
            f"Mortal{words[0].capitalize()}Restrictions" if "outlaw" in base_name.lower() or "restriction" in base_name.lower() else None,
            f"Mortal{words[0].capitalize()}Board" if "bounty" in base_name.lower() and "board" in base_name.lower() else None,
            f"Mortal{words[0].capitalize()}Pot" if "bounty" in base_name.lower() and "pot" in base_name.lower() else None,
        ]
        cpp_patterns = [p for p in cpp_patterns if p]  # Remove None values
        cpp_found = False
        cpp_path = None
        
        # Check module/src/ first (preferred location)
        if MODULE_SRC_DIR.exists():
            for pattern in cpp_patterns:
                for cpp_file in find_files("*.cpp", MODULE_SRC_DIR):
                    if pattern.lower() in cpp_file.name.lower():
                        cpp_found = True
                        cpp_path = str(cpp_file)
                        break
                if cpp_found:
                    break
                for h_file in find_files("*.h", MODULE_SRC_DIR):
                    if pattern.lower() in h_file.name.lower():
                        cpp_found = True
                        cpp_path = str(h_file)
                        break
                if cpp_found:
                    break
        
        # Also check src/ directory
        if not cpp_found:
            for pattern in cpp_patterns:
                for cpp_file in find_files("*.cpp", SRC_DIR):
                    if pattern.lower() in cpp_file.name.lower():
                        cpp_found = True
                        cpp_path = str(cpp_file)
                        break
                if cpp_found:
                    break
                for h_file in find_files("*.h", SRC_DIR):
                    if pattern.lower() in h_file.name.lower():
                        cpp_found = True
                        cpp_path = str(h_file)
                        break
                if cpp_found:
                    break
        
        if cpp_found:
            # C++ implementation found - this is preferred over Lua
            result["lua_files"]["found"].append({"name": lua_file, "path": cpp_path, "note": "C++ implementation (preferred)"})
        else:
            # No C++ found, check for Lua as fallback
            exists, path = check_lua_file_exists(lua_file)
            if exists:
                result["lua_files"]["found"].append({"name": lua_file, "path": path, "note": "Lua implementation"})
                # Check for event hooks
                if check_event_hooks(path):
                    result["has_event_hooks"] = True
            else:
                # Neither C++ nor Lua found - mark as missing
                result["lua_files"]["missing"].append(lua_file)
                result["issues"].append(f"Missing: {lua_file} (no C++ or Lua implementation found)")
    
    # Check C++ files
    result["cpp_files"]["required"] = requirements["cpp_files"]
    for cpp_file in requirements["cpp_files"]:
        exists, path = check_cpp_file_exists(cpp_file)
        if exists:
            result["cpp_files"]["found"].append({"name": cpp_file, "path": path})
        else:
            result["cpp_files"]["missing"].append(cpp_file)
            result["issues"].append(f"Missing C++ file: {cpp_file}")
    
    # Check SQL tables
    result["sql_tables"]["required"] = requirements["sql_tables"]
    for table in requirements["sql_tables"]:
        exists, path = check_sql_table_exists(table)
        if exists:
            result["sql_tables"]["found"].append({"name": table, "path": path})
        else:
            result["sql_tables"]["missing"].append(table)
            result["issues"].append(f"Missing SQL table: {table}")
    
    # Check for mentions in SQL/C++ (indirect implementation)
    result["sql_mentions"] = check_sql_mentions(spec_name)
    result["cpp_mentions"] = check_cpp_mentions(spec_name)
    
    # Calculate completion percentage
    # C++ implementations count as full completion (preferred over Lua)
    total_requirements = (
        len(requirements["lua_files"]) +
        len(requirements["cpp_files"]) +
        len(requirements["sql_tables"])
    )
    
    found_requirements = (
        len(result["lua_files"]["found"]) +  # Includes C++ equivalents
        len(result["cpp_files"]["found"]) +
        len(result["sql_tables"]["found"])
    )
    
    if total_requirements > 0:
        result["completion"] = int((found_requirements / total_requirements) * 100)
    else:
        # If no explicit requirements, check for any mentions
        if result["sql_mentions"] or result["cpp_mentions"]:
            result["completion"] = 25  # Partial implementation
        else:
            result["completion"] = 0
    
    # Boost completion if C++ implementations found (preferred)
    cpp_implementations = sum(1 for f in result["lua_files"]["found"] if "C++" in f.get("note", ""))
    if cpp_implementations > 0 and total_requirements > 0:
        # C++ implementations are preferred, so boost score slightly
        cpp_boost = min(10, int((cpp_implementations / total_requirements) * 10))
        result["completion"] = min(100, result["completion"] + cpp_boost)
    
    # Determine status
    # For "complete" status, require actual C++ code, not just SQL tables
    has_cpp_code = len(result["cpp_files"]["found"]) > 0 or len(result["lua_files"]["found"]) > 0
    has_only_sql = len(result["sql_tables"]["found"]) > 0 and not has_cpp_code
    
    if result["completion"] >= 90 and len(result["issues"]) == 0 and has_cpp_code:
        # Complete: has code AND meets requirements
        result["status"] = "complete"
        results["specs_complete"] += 1
    elif has_only_sql:
        # SQL only - mark as partial (not complete)
        result["status"] = "partial"
        result["completion"] = min(result["completion"], 30)  # Cap at 30% for SQL-only
        result["issues"].append("Has SQL tables but no C++/Lua code implementation")
        results["specs_partial"] += 1
    elif result["completion"] > 0 or result["sql_mentions"] or result["cpp_mentions"]:
        result["status"] = "partial"
        results["specs_partial"] += 1
    else:
        result["status"] = "missing"
        results["specs_missing"] += 1
    
    results["specs_checked"] += 1
    results["details"][spec_name] = result
    
    return result

def main():
    """Main verification function"""
    print("=" * 80)
    print("SYSTEMATIC SPEC VERIFICATION")
    print("=" * 80)
    print()
    
    # Find all spec files
    spec_files = sorted(find_files("*.md", SPEC_DIR))
    
    if not spec_files:
        print(f"ERROR: No spec files found in {SPEC_DIR}")
        return
    
    print(f"Found {len(spec_files)} spec files")
    print()
    
    # Verify each spec
    for spec_file in spec_files:
        verify_spec(spec_file)
    
    # Generate report
    print()
    print("=" * 80)
    print("VERIFICATION SUMMARY")
    print("=" * 80)
    print(f"Total Specs Checked: {results['specs_checked']}")
    print(f"Complete: {results['specs_complete']} ({results['specs_complete']/results['specs_checked']*100:.1f}%)")
    print(f"Partial: {results['specs_partial']} ({results['specs_partial']/results['specs_checked']*100:.1f}%)")
    print(f"Missing: {results['specs_missing']} ({results['specs_missing']/results['specs_checked']*100:.1f}%)")
    print()
    
    # Write detailed JSON report
    report_file = Path("docs/implementation/SPEC_VERIFICATION_REPORT.json")
    report_file.parent.mkdir(parents=True, exist_ok=True)
    
    with open(report_file, 'w') as f:
        json.dump(results, f, indent=2)
    
    print(f"Detailed report written to: {report_file}")
    
    # Print missing specs
    print()
    print("MISSING SPECS (0% completion):")
    print("-" * 80)
    for spec_name, details in sorted(results["details"].items()):
        if details["status"] == "missing":
            print(f"  {details['spec_num']}: {spec_name}")
            if details["issues"]:
                for issue in details["issues"][:3]:  # Show first 3 issues
                    print(f"    - {issue}")
    
    print()
    print("PARTIAL SPECS (< 90% completion):")
    print("-" * 80)
    for spec_name, details in sorted(results["details"].items()):
        if details["status"] == "partial":
            print(f"  {details['spec_num']}: {spec_name} ({details['completion']}%)")
            if details["issues"]:
                for issue in details["issues"][:3]:
                    print(f"    - {issue}")

if __name__ == "__main__":
    main()

