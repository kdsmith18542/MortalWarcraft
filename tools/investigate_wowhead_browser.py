#!/usr/bin/env python3
"""
Mortal Warcraft - Wowhead Browser Investigation Tool

Uses Cursor's automated browser to investigate Wowhead pages.
This tool can be called from within Cursor to use browser automation.

Usage (from Cursor):
    This script provides functions that can be called with browser automation.
    The actual browser calls are made via Cursor's MCP browser extension.

For Issue #16905 (Berserk):
    - Navigate to spell page
    - Extract tooltip data
    - Search comments for "energy"
    - Extract relevant information

For Issue #23830 (Culling):
    - Navigate to zone page
    - Search comments for "wave" or "spawn"
    - Extract coordinate discussions
"""

def investigate_berserk_wowhead():
    """
    Investigate Berserk spell on Wowhead using browser automation.
    
    Returns instructions for browser automation steps.
    """
    steps = [
        {
            'action': 'navigate',
            'url': 'https://www.wowhead.com/wotlk/spell=50334',
            'description': 'Navigate to Berserk spell page'
        },
        {
            'action': 'wait',
            'time': 3,
            'description': 'Wait for page to load'
        },
        {
            'action': 'snapshot',
            'description': 'Take snapshot to see page content'
        },
        {
            'action': 'search_text',
            'text': 'energy',
            'description': 'Search page for "energy" mentions'
        },
        {
            'action': 'extract_tooltip',
            'description': 'Extract spell tooltip data (energy cost, description)'
        },
        {
            'action': 'read_comments',
            'description': 'Read comments section for energy-related discussions'
        }
    ]
    
    return {
        'spell_id': 50334,
        'spell_name': 'Berserk',
        'url': 'https://www.wowhead.com/wotlk/spell=50334',
        'steps': steps,
        'what_to_look_for': [
            'Spell tooltip - does it mention energy cost?',
            'Comments mentioning "energy" or "cat form"',
            'Bug reports about energy consumption',
            'Retail behavior discussions'
        ]
    }

def investigate_culling_wowhead():
    """
    Investigate Culling of Stratholme zone on Wowhead using browser automation.
    
    Returns instructions for browser automation steps.
    """
    steps = [
        {
            'action': 'navigate',
            'url': 'https://www.wowhead.com/wotlk/zone=4100/culling-of-stratholme',
            'description': 'Navigate to Culling of Stratholme zone page'
        },
        {
            'action': 'wait',
            'time': 3,
            'description': 'Wait for page to load'
        },
        {
            'action': 'snapshot',
            'description': 'Take snapshot to see page content'
        },
        {
            'action': 'search_text',
            'text': 'wave',
            'description': 'Search page for "wave" mentions'
        },
        {
            'action': 'search_text',
            'text': 'spawn',
            'description': 'Search page for "spawn" mentions'
        },
        {
            'action': 'read_comments',
            'description': 'Read comments section for wave spawn discussions'
        },
        {
            'action': 'check_npc_pages',
            'npcs': [
                {'id': 27737, 'name': 'Risen Zombie'},
                {'id': 28249, 'name': 'Devouring Ghoul'},
                {'id': 28200, 'name': 'Dark Necromancer'},
                {'id': 28199, 'name': 'Tomb Stalker'}
            ],
            'description': 'Check NPC pages for spawn location information'
        }
    ]
    
    return {
        'zone_id': 4100,
        'zone_name': 'Culling of Stratholme',
        'url': 'https://www.wowhead.com/wotlk/zone=4100/culling-of-stratholme',
        'steps': steps,
        'what_to_look_for': [
            'Comments mentioning "wave spawns" or "spawn positions"',
            'Coordinate discussions',
            'Bug reports about incorrect spawns',
            'NPC spawn location information'
        ]
    }

def get_browser_automation_instructions(issue_number):
    """
    Get browser automation instructions for a specific issue.
    
    Args:
        issue_number: 16905 or 23830
        
    Returns:
        Dictionary with automation steps and instructions
    """
    if issue_number == 16905:
        return investigate_berserk_wowhead()
    elif issue_number == 23830:
        return investigate_culling_wowhead()
    else:
        return None

if __name__ == '__main__':
    import json
    import sys
    
    if len(sys.argv) > 1:
        issue = int(sys.argv[1])
        result = get_browser_automation_instructions(issue)
        if result:
            print(json.dumps(result, indent=2))
        else:
            print(f"Unknown issue: {issue}")
    else:
        print("Usage: python3 investigate_wowhead_browser.py <16905|23830>")
        print("\nThis script provides instructions for browser automation.")
        print("The actual browser automation should be done via Cursor's MCP tools.")

