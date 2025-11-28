#!/usr/bin/env python3
"""
Mortal Warcraft - GitHub Pull Requests Fetcher

Fetches PR data from GitHub using the REST API.
Useful for finding existing fixes that might save time.

Usage:
    python3 fetch_github_prs.py --repo azerothcore/azerothcore-wotlk --search "berserk"
    python3 fetch_github_prs.py --repo azerothcore/azerothcore-wotlk --issue 16905
    python3 fetch_github_prs.py --repo azerothcore/azerothcore-wotlk --state open --limit 20
"""

import argparse
import json
import sys
from urllib.request import urlopen, Request
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode

GITHUB_API_BASE = "https://api.github.com"

def fetch_prs(repo, state='open', limit=30, token=None):
    """
    Fetch pull requests from GitHub API.
    
    Args:
        repo: Repository in format "owner/repo"
        state: PR state (open, closed, all)
        limit: Maximum number of PRs to return
        token: Optional GitHub token for higher rate limits
        
    Returns:
        List of PR dictionaries
    """
    params = {
        'state': state,
        'per_page': min(limit, 100),
        'page': 1,
        'sort': 'updated',
        'direction': 'desc'
    }
    
    url = f"{GITHUB_API_BASE}/repos/{repo}/pulls?{urlencode(params)}"
    
    headers = {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'MortalWarcraft-Investigation-Tool'
    }
    
    if token:
        headers['Authorization'] = f'token {token}'
    
    all_prs = []
    
    try:
        while len(all_prs) < limit:
            request = Request(url, headers=headers)
            with urlopen(request) as response:
                data = json.loads(response.read().decode())
                all_prs.extend(data[:limit - len(all_prs)])
                
                if len(data) < params['per_page'] or len(all_prs) >= limit:
                    break
                
                params['page'] += 1
                url = f"{GITHUB_API_BASE}/repos/{repo}/pulls?{urlencode(params)}"
        
        return all_prs
    except (HTTPError, URLError, json.JSONDecodeError) as e:
        print(f"Error: {e}", file=sys.stderr)
        return []

def search_prs_by_issue(repo, issue_number, token=None):
    """
    Search for PRs that reference a specific issue.
    
    Args:
        repo: Repository in format "owner/repo"
        issue_number: Issue number to search for
        token: Optional GitHub token
        
    Returns:
        List of PRs that reference the issue
    """
    # Search for PRs that mention the issue
    query = f"repo:{repo} type:pr {issue_number}"
    url = f"{GITHUB_API_BASE}/search/issues?q={query.replace(' ', '+')}"
    
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
            return data.get('items', [])
    except (HTTPError, URLError, json.JSONDecodeError) as e:
        print(f"Warning: Could not search PRs: {e}", file=sys.stderr)
        return []

def search_prs_by_keywords(repo, keywords, token=None):
    """
    Search PRs by keywords in title/body.
    
    Args:
        repo: Repository in format "owner/repo"
        keywords: Search query
        token: Optional GitHub token
        
    Returns:
        List of matching PRs
    """
    query = f"repo:{repo} type:pr {keywords}"
    url = f"{GITHUB_API_BASE}/search/issues?q={query.replace(' ', '+')}"
    
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
            return data.get('items', [])
    except (HTTPError, URLError, json.JSONDecodeError) as e:
        print(f"Warning: Could not search PRs: {e}", file=sys.stderr)
        return []

def format_pr_output(prs, show_details=False):
    """Format PR data for display."""
    if not prs:
        return "No PRs found."
    
    output = []
    output.append(f"Found {len(prs)} pull requests:\n")
    
    for pr in prs:
        output.append(f"#{pr['number']}: {pr['title']}")
        output.append(f"  URL: {pr['html_url']}")
        output.append(f"  State: {pr['state']}")
        output.append(f"  Created: {pr['created_at']}")
        output.append(f"  Updated: {pr['updated_at']}")
        
        if pr.get('merged_at'):
            output.append(f"  Merged: {pr['merged_at']}")
        
        if pr.get('labels'):
            labels = [label['name'] for label in pr['labels']]
            output.append(f"  Labels: {', '.join(labels)}")
        
        if pr.get('user'):
            output.append(f"  Author: {pr['user']['login']}")
        
        if pr.get('draft'):
            output.append(f"  Draft: Yes")
        
        if show_details and pr.get('body'):
            body_preview = pr['body'][:300].replace('\n', ' ')
            if len(pr['body']) > 300:
                body_preview += "..."
            output.append(f"  Description: {body_preview}")
        
        output.append("")  # Blank line between PRs
    
    return "\n".join(output)

def main():
    parser = argparse.ArgumentParser(description='Fetch GitHub pull requests')
    parser.add_argument('--repo', default='azerothcore/azerothcore-wotlk',
                       help='Repository (default: azerothcore/azerothcore-wotlk)')
    parser.add_argument('--state', default='open', choices=['open', 'closed', 'all'],
                       help='PR state (default: open)')
    parser.add_argument('--limit', type=int, default=30,
                       help='Maximum number of PRs to return (default: 30)')
    parser.add_argument('--token', type=str,
                       help='GitHub token for higher rate limits (optional)')
    parser.add_argument('--issue', type=int,
                       help='Search for PRs referencing a specific issue number')
    parser.add_argument('--search', type=str,
                       help='Search for PRs by keywords')
    parser.add_argument('--details', action='store_true',
                       help='Show PR descriptions')
    parser.add_argument('--json', action='store_true',
                       help='Output as JSON')
    
    args = parser.parse_args()
    
    if args.issue:
        prs = search_prs_by_issue(args.repo, args.issue, args.token)
    elif args.search:
        prs = search_prs_by_keywords(args.repo, args.search, args.token)
    else:
        prs = fetch_prs(args.repo, args.state, args.limit, args.token)
    
    if args.json:
        print(json.dumps(prs, indent=2))
    else:
        print(format_pr_output(prs, args.details))
    
    return 0 if prs else 1

if __name__ == '__main__':
    exit(main())

