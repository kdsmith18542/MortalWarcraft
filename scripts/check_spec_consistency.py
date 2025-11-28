#!/usr/bin/env python3
"""
Check spec documents for consistency issues:
- Naming conventions
- Duplicate requirements
- Inconsistent terminology
- Missing cross-references
"""

import re
from pathlib import Path
from collections import defaultdict

SPEC_DIR = Path("docs/specs")

def check_naming_consistency():
    """Check for inconsistent naming across specs"""
    issues = []
    
    # Common terms that should be consistent
    term_variations = {
        "Crimson Phial": ["crimson phial", "Crimson Flask", "crimson flask", "phial"],
        "Runes of Mastery": ["runes of mastery", "Rune of Mastery", "mastery runes"],
        "Guard Counter": ["guard counter", "Guard Counter", "guardcounter"],
        "Notoriety": ["notoriety", "Notoriety", "reputation"],
        "Outlaw": ["outlaw", "Outlaw", "criminal"],
        "Stronghold": ["stronghold", "Stronghold", "fortress", "base"],
        "Risk Zone": ["risk zone", "Risk Zone", "risk-zone", "pvp zone"],
    }
    
    all_specs = list(SPEC_DIR.glob("*.md"))
    
    for term, variations in term_variations.items():
        found_terms = defaultdict(list)
        
        for spec_file in all_specs:
            try:
                with open(spec_file, 'r', encoding='utf-8') as f:
                    content = f.read()
                    
                    for variation in variations + [term]:
                        if re.search(rf'\b{re.escape(variation)}\b', content, re.IGNORECASE):
                            found_terms[variation].append(spec_file.name)
            except:
                continue
        
        if len(found_terms) > 1:
            issues.append({
                "type": "naming_inconsistency",
                "term": term,
                "variations": dict(found_terms)
            })
    
    return issues

def check_duplicate_requirements():
    """Check for duplicate file requirements across specs"""
    all_requirements = defaultdict(list)
    
    for spec_file in SPEC_DIR.glob("*.md"):
        try:
            with open(spec_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
                # Find all file mentions
                patterns = [
                    r'`([a-z_]+\.(lua|cpp|h))`',
                    r'([A-Z][a-zA-Z]+\.(cpp|h))',
                ]
                
                for pattern in patterns:
                    for match in re.finditer(pattern, content):
                        filename = match.group(1)
                        all_requirements[filename].append(spec_file.name)
        except:
            continue
    
    duplicates = {f: specs for f, specs in all_requirements.items() if len(specs) > 1}
    return duplicates

def check_cross_references():
    """Check for broken cross-references between specs"""
    issues = []
    
    # Find all spec references
    spec_refs = {}
    for spec_file in SPEC_DIR.glob("*.md"):
        spec_refs[spec_file.stem] = spec_file.name
    
    for spec_file in SPEC_DIR.glob("*.md"):
        try:
            with open(spec_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
                # Find references to other specs
                ref_pattern = r'`(\d+-\w+(?:-\w+)*\.md)`|(\d+-\w+(?:-\w+)*)\.md'
                for match in re.finditer(ref_pattern, content):
                    ref = match.group(1) or match.group(2)
                    if ref not in spec_refs:
                        issues.append({
                            "spec": spec_file.name,
                            "type": "broken_reference",
                            "reference": ref
                        })
        except:
            continue
    
    return issues

def check_implementation_sections():
    """Check that implementation sections are consistent"""
    issues = []
    
    for spec_file in SPEC_DIR.glob("*.md"):
        try:
            with open(spec_file, 'r', encoding='utf-8') as f:
                content = f.read()
                
                # Check for implementation section
                has_impl = "## 13. Implementation" in content or "## Implementation" in content or "## 9. Technical Implementation" in content
                
                # Check for C++ preference note
                has_cpp_note = "C++ rather than Lua" in content or "C++ implementation" in content
                
                # If spec has Lua requirements, should have C++ note
                has_lua = bool(re.search(r'\.lua', content, re.IGNORECASE))
                
                if has_lua and not has_cpp_note and has_impl:
                    issues.append({
                        "spec": spec_file.name,
                        "type": "missing_cpp_note",
                        "issue": "Has Lua requirements but no C++ preference note"
                    })
        except:
            continue
    
    return issues

def main():
    """Main consistency check"""
    print("=" * 80)
    print("SPEC CONSISTENCY CHECK")
    print("=" * 80)
    print()
    
    # Check naming
    print("Checking naming consistency...")
    naming_issues = check_naming_consistency()
    if naming_issues:
        print(f"Found {len(naming_issues)} naming inconsistencies:")
        for issue in naming_issues[:5]:  # Show first 5
            print(f"  - {issue['term']}: {len(issue['variations'])} variations found")
    else:
        print("  ✓ Naming is consistent")
    print()
    
    # Check duplicates
    print("Checking duplicate requirements...")
    duplicates = check_duplicate_requirements()
    if duplicates:
        print(f"Found {len(duplicates)} files mentioned in multiple specs:")
        for filename, specs in list(duplicates.items())[:10]:  # Show first 10
            print(f"  - {filename}: {len(specs)} specs")
    else:
        print("  ✓ No duplicate requirements")
    print()
    
    # Check cross-references
    print("Checking cross-references...")
    ref_issues = check_cross_references()
    if ref_issues:
        print(f"Found {len(ref_issues)} broken references:")
        for issue in ref_issues[:10]:  # Show first 10
            print(f"  - {issue['spec']}: references {issue['reference']}")
    else:
        print("  ✓ All cross-references valid")
    print()
    
    # Check implementation sections
    print("Checking implementation sections...")
    impl_issues = check_implementation_sections()
    if impl_issues:
        print(f"Found {len(impl_issues)} specs missing C++ preference notes:")
        for issue in impl_issues[:10]:  # Show first 10
            print(f"  - {issue['spec']}: {issue['issue']}")
    else:
        print("  ✓ Implementation sections are consistent")
    print()
    
    print("=" * 80)
    print("Summary:")
    print(f"  Naming issues: {len(naming_issues)}")
    print(f"  Duplicate requirements: {len(duplicates)}")
    print(f"  Broken references: {len(ref_issues)}")
    print(f"  Missing C++ notes: {len(impl_issues)}")

if __name__ == "__main__":
    main()

