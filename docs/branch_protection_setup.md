# Branch Protection Setup for AgriTrace

## Overview
This document provides instructions for setting up branch protection rules for the AgriTrace repository to ensure code quality and maintain a professional Git workflow.

## Branch Protection Rules for `main` Branch

### Steps to Enable Branch Protection Rules

1. Go to the AgriTrace repository on GitHub
2. Click on "Settings" tab
3. In the left sidebar, click on "Branches"
4. Under "Branch protection rules", click "Add rule"
5. In the "Branch name pattern" field, enter `main`
6. Configure the following protection settings:

### Required Settings

- [x] **Require a pull request before merging**
  - [x] Require approvals (at least 1 reviewer)
  - [x] Dismiss stale pull request approvals when new commits are pushed

- [x] **Require status checks to pass before merging**
  - [x] Require branches to be up to date before merging
  - Status checks to require:
    - [x] `backend-tests` (from GitHub Actions CI workflow)
    - [x] `frontend-tests` (from GitHub Actions CI workflow)

- [x] **Require conversation resolution before merging**
  - Ensures all comments and discussions are resolved

- [x] **Do not allow bypassing the above settings**
  - Applies rules to administrators as well

### Additional Recommended Settings

- [ ] **Restrict who can push to matching branches**
  - Limit push access to specific users or teams

- [ ] **Allow force pushes**
  - Keep this unchecked to prevent history rewriting

- [ ] **Allow deletions**
  - Keep this unchecked to prevent branch deletion

## Branch Protection Rules for `develop` Branch

Similar but slightly less restrictive rules should be applied to the `develop` branch:

1. Follow the same steps as above but enter `develop` in the "Branch name pattern" field
2. Configure the following protection settings:

- [x] **Require a pull request before merging**
  - [x] Require approvals (at least 1 reviewer)

- [x] **Require status checks to pass before merging**
  - [x] Require branches to be up to date before merging
  - Status checks to require:
    - [x] `backend-tests` (from GitHub Actions CI workflow)
    - [x] `frontend-tests` (from GitHub Actions CI workflow)

## Git Workflow

With these branch protection rules in place, the recommended Git workflow is:

1. Create feature branches from `develop`
2. Make changes and commit to feature branches
3. Open pull requests to merge feature branches into `develop`
4. Ensure CI checks pass and get code review approval
5. Merge approved pull requests into `develop`
6. Periodically, create release branches from `develop`
7. Test release branches thoroughly
8. Open pull requests to merge release branches into `main`
9. After approval and passing all checks, merge into `main`
10. Tag the merge commit in `main` with a version number
