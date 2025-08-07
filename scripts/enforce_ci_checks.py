#!/usr/bin/env python3
"""
Script to verify GitHub branch protection settings for AgriTrace repository.
This script uses the GitHub API to check if branch protection rules are properly configured
for both main and develop branches, ensuring CI checks are required before merging.
"""

import os
import sys
import requests
import argparse
from getpass import getpass


def check_branch_protection(repo_owner, repo_name, branch, token):
    """
    Check branch protection settings for a specific branch.
    
    Args:
        repo_owner (str): GitHub username or organization name
        repo_name (str): Repository name
        branch (str): Branch name to check
        token (str): GitHub personal access token
        
    Returns:
        dict: Branch protection settings or None if not found
    """
    url = f"https://api.github.com/repos/{repo_owner}/{repo_name}/branches/{branch}/protection"
    headers = {
        "Accept": "application/vnd.github.v3+json",
        "Authorization": f"token {token}"
    }
    
    response = requests.get(url, headers=headers)
    
    if response.status_code == 200:
        return response.json()
    elif response.status_code == 404:
        print(f"⚠️ Branch protection not enabled for {branch} branch")
        return None
    else:
        print(f"❌ Error checking branch protection: {response.status_code}")
        print(response.text)
        return None


def verify_required_status_checks(protection_data, branch):
    """
    Verify that required status checks are properly configured.
    
    Args:
        protection_data (dict): Branch protection settings
        branch (str): Branch name
        
    Returns:
        bool: True if properly configured, False otherwise
    """
    if not protection_data:
        return False
    
    # Check if required status checks are enabled
    if "required_status_checks" not in protection_data:
        print(f"❌ Required status checks not enabled for {branch} branch")
        return False
    
    status_checks = protection_data["required_status_checks"]
    
    # Check if strict mode is enabled (require branches to be up to date)
    if not status_checks.get("strict", False):
        print(f"⚠️ Branches are not required to be up to date before merging for {branch} branch")
    
    # Check for required CI checks
    contexts = status_checks.get("contexts", [])
    required_checks = ["backend-tests", "frontend-tests"]
    
    missing_checks = [check for check in required_checks if check not in contexts]
    
    if missing_checks:
        print(f"❌ Missing required status checks for {branch} branch: {', '.join(missing_checks)}")
        return False
    
    return True


def main():
    parser = argparse.ArgumentParser(description="Verify GitHub branch protection settings")
    parser.add_argument("--owner", required=True, help="GitHub username or organization name")
    parser.add_argument("--repo", required=True, help="Repository name")
    parser.add_argument("--token", help="GitHub personal access token (will prompt if not provided)")
    
    args = parser.parse_args()
    
    token = args.token or getpass("Enter GitHub personal access token: ")
    
    branches = ["main", "develop"]
    all_checks_passed = True
    
    for branch in branches:
        print(f"\nChecking protection settings for {branch} branch...")
        protection_data = check_branch_protection(args.owner, args.repo, branch, token)
        
        if not protection_data:
            all_checks_passed = False
            continue
        
        # Check for required pull request reviews
        if "required_pull_request_reviews" not in protection_data:
            print(f"❌ Pull request reviews not required for {branch} branch")
            all_checks_passed = False
        
        # Check for required status checks
        if not verify_required_status_checks(protection_data, branch):
            all_checks_passed = False
    
    if all_checks_passed:
        print("\n✅ All branch protection settings are properly configured!")
        return 0
    else:
        print("\n⚠️ Some branch protection settings need to be fixed. See the warnings above.")
        return 1


if __name__ == "__main__":
    sys.exit(main())
