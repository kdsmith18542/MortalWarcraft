#!/usr/bin/env python3
"""
Mortal Warcraft - GitHub Issues Lister

Lists open issues from GitHub with details.
Much faster than browser automation for issue tracking.

Usage:
    python3 list_github_issues.py --repo azerothcore/azerothcore-wotlk
    python3 list_github_issues.py --repo azerothcore/azerothcore-wotlk --labels "Confirmed,Players-feedback"
    python3 list_github_issues.py --repo azerothcore/azerothcore-wotlk --limit 50
"""

import argparse
import json
import sys
from urllib.request import urlopen, Request
from urllib.error import HTTPError, URLError
from urllib.parse import urlencode

GITHUB_API_BASE = "https://api.github.com"

def fetch_issues(repo, state='open', labels=None, limit=30, token=None):
    """
    Fetch issues from GitHub API.
    
    Args:
        repo: Repository in format "owner/repo"
        state: Issue state (open, closed, all)
        labels: Comma-separated list of labels to filter by
        limit: Maximum number of issues to return
        token: Optional GitHub token for higher rate limits
        
    Returns:
        List of issue dictionaries
    """
    params = {
        'state': state,
        'per_page': min(limit, 100),  # GitHub max is 100 per page
        'page': 1
    }
    
    if labels:
        params['labels'] = labels
    
    url = f"{GITHUB_API_BASE}/repos/{repo}/issues?{urlencode(params)}"
    
    headers = {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'MortalWarcraft-Investigation-Tool'
    }
    
    if token:
        headers['Authorization'] = f'token {token}'
    
    all_issues = []
    
    try:
        while len(all_issues) < limit:
            request = Request(url, headers=headers)
            with urlopen(request) as response:
                data = json.loads(response.read().decode())
                
                # Filter out pull requests (they appear in issues API)
                issues = [item for item in data if 'pull_request' not in item]
                all_issues.extend(issues[:limit - len(all_issues)])
                
                if len(data) < params['per_page'] or len(all_issues) >= limit:
                    break
                
                # Check for next page
                link_header = response.headers.get('Link', '')
                if 'rel="next"' not in link_header:
                    break
                
                # Extract next page URL
                params['page'] += 1
                url = f"{GITHUB_API_BASE}/repos/{repo}/issues?{urlencode(params)}"
        
        return all_issues
    except HTTPError as e:
        if e.code == 404:
            print(f"Error: Repository {repo} not found", file=sys.stderr)
        elif e.code == 403:
            print(f"Error: Rate limit exceeded. Use --token for higher limits", file=sys.stderr)
        else:
            print(f"Error: HTTP {e.code} - {e.reason}", file=sys.stderr)
        return []
    except (URLError, json.JSONDecodeError) as e:
        print(f"Error: {e}", file=sys.stderr)
        return []

def format_issue_list(issues, show_details=False):
    """Format issues for display."""
    if not issues:
        return "No issues found."
    
    output = []
    output.append(f"Found {len(issues)} open issues:\n")
    
    for issue in issues:
        output.append(f"#{issue['number']}: {issue['title']}")
        output.append(f"  URL: {issue['html_url']}")
        output.append(f"  State: {issue['state']}")
        output.append(f"  Created: {issue['created_at']}")
        
        if issue.get('labels'):
            labels = [label['name'] for label in issue['labels']]
            output.append(f"  Labels: {', '.join(labels)}")
        
        if issue.get('assignee'):
            output.append(f"  Assignee: {issue['assignee']['login']}")
        
        if show_details and issue.get('body'):
            body_preview = issue['body'][:200].replace('\n', ' ')
            if len(issue['body']) > 200:
                body_preview += "..."
            output.append(f"  Description: {body_preview}")
        
        output.append("")  # Blank line between issues
    
    return "\n".join(output)

def main():
    parser = argparse.ArgumentParser(description='List GitHub issues')
    parser.add_argument('--repo', default='azerothcore/azerothcore-wotlk',
                       help='Repository (default: azerothcore/azerothcore-wotlk)')
    parser.add_argument('--state', default='open', choices=['open', 'closed', 'all'],
                       help='Issue state (default: open)')
    parser.add_argument('--labels', type=str,
                       help='Comma-separated list of labels to filter by')
    parser.add_argument('--limit', type=int, default=30,
                       help='Maximum number of issues to return (default: 30)')
    parser.add_argument('--token', type=str,
                       help='GitHub token for higher rate limits (optional)')
    parser.add_argument('--details', action='store_true',
                       help='Show issue descriptions')
    parser.add_argument('--json', action='store_true',
                       help='Output as JSON')
    
    args = parser.parse_args()
    
    issues = fetch_issues(args.repo, args.state, args.labels, args.limit, args.token)
    
    if args.json:
        print(json.dumps(issues, indent=2))
    else:
        print(format_issue_list(issues, args.details))
    
    return 0 if issues else 1

if __name__ == '__main__':
    exit(main())

