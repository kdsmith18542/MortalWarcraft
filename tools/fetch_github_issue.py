#!/usr/bin/env python3
"""
Mortal Warcraft - GitHub Issue Fetcher

Fetches issue data from GitHub using the REST API.
Much faster than browser automation for reading issues.

Usage:
    python3 fetch_github_issue.py --repo azerothcore/azerothcore-wotlk --issue 16905
    python3 fetch_github_issue.py --repo azerothcore/azerothcore-wotlk --issue 23830
"""

import argparse
import json
import sys
from urllib.request import urlopen, Request
from urllib.error import HTTPError, URLError

GITHUB_API_BASE = "https://api.github.com"

def fetch_issue(repo, issue_number, token=None):
    """
    Fetch issue data from GitHub API.
    
    Args:
        repo: Repository in format "owner/repo"
        issue_number: Issue number
        token: Optional GitHub token for higher rate limits
        
    Returns:
        Dictionary with issue data or None on error
    """
    url = f"{GITHUB_API_BASE}/repos/{repo}/issues/{issue_number}"
    
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
            print(f"Error: Issue #{issue_number} not found in {repo}", file=sys.stderr)
        elif e.code == 403:
            print(f"Error: Rate limit exceeded. Use --token for higher limits", file=sys.stderr)
        else:
            print(f"Error: HTTP {e.code} - {e.reason}", file=sys.stderr)
        return None
    except URLError as e:
        print(f"Error: {e.reason}", file=sys.stderr)
        return None
    except json.JSONDecodeError as e:
        print(f"Error: Invalid JSON response - {e}", file=sys.stderr)
        return None

def fetch_issue_comments(repo, issue_number, token=None):
    """
    Fetch comments for an issue.
    
    Args:
        repo: Repository in format "owner/repo"
        issue_number: Issue number
        token: Optional GitHub token
        
    Returns:
        List of comment dictionaries
    """
    url = f"{GITHUB_API_BASE}/repos/{repo}/issues/{issue_number}/comments"
    
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
    except (HTTPError, URLError, json.JSONDecodeError) as e:
        print(f"Warning: Could not fetch comments: {e}", file=sys.stderr)
        return []

def format_issue_output(issue, comments=None):
    """Format issue data for display."""
    output = []
    output.append("=" * 80)
    output.append(f"Issue #{issue['number']}: {issue['title']}")
    output.append("=" * 80)
    output.append(f"\nURL: {issue['html_url']}")
    output.append(f"State: {issue['state']}")
    output.append(f"Created: {issue['created_at']}")
    output.append(f"Updated: {issue['updated_at']}")
    
    if issue.get('closed_at'):
        output.append(f"Closed: {issue['closed_at']}")
    
    if issue.get('labels'):
        labels = [label['name'] for label in issue['labels']]
        output.append(f"Labels: {', '.join(labels)}")
    
    if issue.get('assignee'):
        output.append(f"Assignee: {issue['assignee']['login']}")
    
    output.append(f"\nDescription:")
    output.append("-" * 80)
    output.append(issue['body'] if issue.get('body') else "(No description)")
    output.append("-" * 80)
    
    if comments:
        output.append(f"\nComments ({len(comments)}):")
        output.append("-" * 80)
        for i, comment in enumerate(comments[:10], 1):  # First 10 comments
            output.append(f"\nComment #{i} by {comment['user']['login']} ({comment['created_at']}):")
            output.append(comment['body'])
            output.append("-" * 80)
        
        if len(comments) > 10:
            output.append(f"\n... and {len(comments) - 10} more comments")
    
    return "\n".join(output)

def search_issues_by_keywords(repo, keywords, token=None):
    """
    Search issues by keywords using GitHub API.
    
    Args:
        repo: Repository in format "owner/repo"
        keywords: Search query
        token: Optional GitHub token
        
    Returns:
        List of matching issues
    """
    # GitHub search API format
    query = f"repo:{repo} {keywords} type:issue"
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
        print(f"Warning: Could not search issues: {e}", file=sys.stderr)
        return []

def main():
    parser = argparse.ArgumentParser(description='Fetch GitHub issue data')
    parser.add_argument('--repo', default='azerothcore/azerothcore-wotlk',
                       help='Repository (default: azerothcore/azerothcore-wotlk)')
    parser.add_argument('--issue', type=int,
                       help='Issue number to fetch')
    parser.add_argument('--search', type=str,
                       help='Search for issues by keywords')
    parser.add_argument('--token', type=str,
                       help='GitHub token for higher rate limits (optional)')
    parser.add_argument('--comments', action='store_true',
                       help='Include comments in output')
    parser.add_argument('--json', action='store_true',
                       help='Output as JSON')
    
    args = parser.parse_args()
    
    if args.search:
        # Search mode
        issues = search_issues_by_keywords(args.repo, args.search, args.token)
        if args.json:
            print(json.dumps(issues, indent=2))
        else:
            print(f"Found {len(issues)} issues matching '{args.search}':")
            for issue in issues[:20]:  # First 20 results
                print(f"  #{issue['number']}: {issue['title']} - {issue['html_url']}")
    elif args.issue:
        # Fetch specific issue
        issue = fetch_issue(args.repo, args.issue, args.token)
        if not issue:
            return 1
        
        comments = None
        if args.comments:
            comments = fetch_issue_comments(args.repo, args.issue, args.token)
        
        if args.json:
            output = {'issue': issue}
            if comments:
                output['comments'] = comments
            print(json.dumps(output, indent=2))
        else:
            print(format_issue_output(issue, comments))
    else:
        parser.print_help()
        return 1
    
    return 0

if __name__ == '__main__':
    exit(main())

