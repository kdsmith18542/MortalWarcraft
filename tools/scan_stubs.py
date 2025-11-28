#!/usr/bin/env python3
"""
Stub Scanner - Finds incomplete implementations in C++/Lua code
"""
import os
import re
from pathlib import Path
from collections import defaultdict

# Stub patterns to search for
STUB_PATTERNS = [
    (r'//\s*(TODO|FIXME|STUB|HACK|XXX)', 'Comment marker'),
    (r'throw\s+.*"[Nn]ot\s+[Ii]mplemented', 'Not implemented exception'),
    (r'return\s+false;\s*//.*stub', 'Stubbed return false'),
    (r'return\s+true;\s*//.*stub', 'Stubbed return true'),
    (r'return\s+nullptr;\s*//.*stub', 'Stubbed return nullptr'),
    (r'return\s+0;\s*//.*stub', 'Stubbed return 0'),
    (r'LOG_ERROR.*[Nn]ot\s+[Ii]mplemented', 'Not implemented log'),
    (r'std::cout.*[Nn]ot\s+[Ii]mplemented', 'Not implemented cout'),
    (r'{\s*//\s*TODO', 'Empty function with TODO'),
    (r'--\s*TODO', 'SQL TODO'),
    (r'--\s*STUB', 'SQL STUB'),
]

# Empty/near-empty function pattern
EMPTY_FUNCTION_PATTERN = r'(void|bool|int|uint32_t?|float)\s+(\w+)\s*\([^)]*\)\s*{\s*(?://[^\n]*)?\s*}'

def scan_file(filepath):
    """Scan a single file for stub patterns"""
    results = []
    try:
        with open(filepath, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            lines = content.split('\n')
            
            for line_num, line in enumerate(lines, 1):
                for pattern, description in STUB_PATTERNS:
                    if re.search(pattern, line, re.IGNORECASE):
                        results.append({
                            'file': filepath,
                            'line': line_num,
                            'content': line.strip(),
                            'type': description
                        })
            
            # Check for empty functions
            for match in re.finditer(EMPTY_FUNCTION_PATTERN, content):
                line_num = content[:match.start()].count('\n') + 1
                results.append({
                    'file': filepath,
                    'line': line_num,
                    'content': match.group(0),
                    'type': 'Empty function'
                })
                
    except Exception as e:
        print(f"Error scanning {filepath}: {e}")
    
    return results

def scan_directory(directory, extensions):
    """Recursively scan directory for files with given extensions"""
    all_results = defaultdict(list)
    
    for ext in extensions:
        for filepath in Path(directory).rglob(f'*{ext}'):
            # Skip build directories and dependencies
            if any(skip in str(filepath) for skip in ['build/', 'deps/', 'target/', 'node_modules/', '.git/']):
                continue
                
            results = scan_file(filepath)
            if results:
                all_results[str(filepath)].extend(results)
    
    return all_results

def main():
    base_dir = '/home/keith/wowpack'
    
    print("=== Scanning for Stubs in Mortal Overhaul C++ Code ===\n")
    
    # Scan C++ module files
    cpp_results = scan_directory(
        f'{base_dir}/azerothcore/modules/mortal_overhaul/src',
        ['.cpp', '.h']
    )
    
    print(f"Found stubs in {len(cpp_results)} C++ files\n")
    
    # Group by file and type
    summary = defaultdict(lambda: defaultdict(int))
    
    for filepath, issues in cpp_results.items():
        rel_path = filepath.replace(f'{base_dir}/', '')
        for issue in issues:
            summary[rel_path][issue['type']] += 1
    
    # Print summary
    print("=== Summary by File ===\n")
    for filepath in sorted(summary.keys()):
        print(f"\n{filepath}")
        for stub_type, count in sorted(summary[filepath].items()):
            print(f"  - {stub_type}: {count}")
    
    # Print detailed results for files with > 5 issues
    print("\n\n=== Detailed Results (files with 5+ issues) ===\n")
    
    for filepath, issues in sorted(cpp_results.items()):
        if len(issues) >= 5:
            rel_path = filepath.replace(f'{base_dir}/', '')
            print(f"\n{rel_path} ({len(issues)} issues):")
            for issue in issues[:10]:  # Show first 10
                print(f"  Line {issue['line']}: {issue['type']}")
                print(f"    {issue['content'][:100]}")
            if len(issues) > 10:
                print(f"  ... and {len(issues) - 10} more")

if __name__ == '__main__':
    main()

