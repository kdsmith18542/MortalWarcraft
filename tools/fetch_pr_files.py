#!/usr/bin/env python3
"""
Mortal Warcraft - GitHub PR Files Fetcher

Fetches the files changed in a PR to review code changes.

Usage:
    python3 fetch_pr_files.py --repo azerothcore/azerothcore-wotlk --pr 23848
"""

import argparse
import json
import sys
from urllib.request import urlopen, Request
from urllib.error import HTTPError, URLError

GITHUB_API_BASE = "https://api.github.com"

def fetch_pr_files(repo, pr_number, token=None):
    """
    Fetch files changed in a PR.
    
    Args:
        repo: Repository in format "owner/repo"
        pr_number: PR number
        token: Optional GitHub token
        
    Returns:
        List of file change dictionaries
    """
    url = f"{GITHUB_API_BASE}/repos/{repo}/pulls/{pr_number}/files"
    
    headers = {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'MortalWarcraft-Investigation-Tool'
    }
    
    if token:
        headers['Authorization'] = f'token {token}'
    
    try:
        request = Request(url, headers=headers)
        with urlopen(request) as response:
            data = json.loads(response.read().decode())
            return data
    except HTTPError as e:
        if e.code == 404:
            print(f"Error: PR #{pr_number} not found in {repo}", file=sys.stderr)
        elif e.code == 403:
            print(f"Error: Rate limit exceeded. Use --token for higher limits", file=sys.stderr)
        else:
            print(f"Error: HTTP {e.code} - {e.reason}", file=sys.stderr)
        return []
    except (URLError, json.JSONDecodeError) as e:
        print(f"Error: {e}", file=sys.stderr)
        return []

def fetch_pr_info(repo, pr_number, token=None):
    """Fetch PR information."""
    url = f"{GITHUB_API_BASE}/repos/{repo}/pulls/{pr_number}"
    
    headers = {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'MortalWarcraft-Investigation-Tool'
    }
    
    if token:
        headers['Authorization'] = f'token {token}'
    
    try:
        request = Request(url, headers=headers)
        with urlopen(request) as response:
            return json.loads(response.read().decode())
    except (HTTPError, URLError, json.JSONDecodeError) as e:
        print(f"Error: {e}", file=sys.stderr)
        return None

def format_file_changes(files):
    """Format file changes for display."""
    if not files:
        return "No files changed."
    
    output = []
    output.append(f"Files changed: {len(files)}\n")
    
    for file in files:
        output.append(f"File: {file['filename']}")
        output.append(f"  Status: {file['status']}")
        output.append(f"  Additions: +{file['additions']}")
        output.append(f"  Deletions: -{file['deletions']}")
        output.append(f"  Changes: {file['changes']}")
        
        if file.get('patch'):
            # Show first 50 lines of patch
            patch_lines = file['patch'].split('\n')[:50]
            output.append(f"  Patch preview:")
            for line in patch_lines:
                output.append(f"    {line}")
            if len(file['patch'].split('\n')) > 50:
                output.append(f"    ... ({len(file['patch'].split('\n')) - 50} more lines)")
        
        output.append("")
    
    return "\n".join(output)

def main():
    parser = argparse.ArgumentParser(description='Fetch GitHub PR file changes')
    parser.add_argument('--repo', default='azerothcore/azerothcore-wotlk',
                       help='Repository (default: azerothcore/azerothcore-wotlk)')
    parser.add_argument('--pr', type=int, required=True,
                       help='PR number')
    parser.add_argument('--token', type=str,
                       help='GitHub token for higher rate limits (optional)')
    parser.add_argument('--json', action='store_true',
                       help='Output as JSON')
    
    args = parser.parse_args()
    
    pr_info = fetch_pr_info(args.repo, args.pr, args.token)
    files = fetch_pr_files(args.repo, args.pr, args.token)
    
    if args.json:
        print(json.dumps({'pr_info': pr_info, 'files': files}, indent=2))
    else:
        if pr_info:
            print("=" * 80)
            print(f"PR #{pr_info['number']}: {pr_info['title']}")
            print("=" * 80)
            print(f"URL: {pr_info['html_url']}")
            print(f"State: {pr_info['state']}")
            print(f"Author: {pr_info['user']['login']}")
            print(f"Base: {pr_info['base']['ref']} <- Head: {pr_info['head']['ref']}")
            print(f"Mergeable: {pr_info.get('mergeable', 'unknown')}")
            print()
        
        print(format_file_changes(files))
    
    return 0 if files else 1

if __name__ == '__main__':
    exit(main())

