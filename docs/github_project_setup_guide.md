# GitHub Project Board Setup Guide for AgriTrace

This guide provides step-by-step instructions for setting up a GitHub project board that meets the exemplary criteria for project management in the rubric.

## Prerequisites
- GitHub account with access to the AgriTrace repository
- Admin/write permissions for the repository

## Step 1: Access the Project Board

1. Log in to your GitHub account
2. Navigate to the AgriTrace repository: https://github.com/renoir01/AgriTrace
3. Click on the "Projects" tab
4. If project #1 already exists, click on it; otherwise, click "New project"

## Step 2: Set Up Board Columns

If creating a new project:
1. Choose "Board" as the template
2. Name it "AgriTrace Development Board"
3. Click "Create"

Set up the following columns:
1. **Backlog**: Tasks identified but not yet ready for development
2. **To Do**: Tasks ready for development in the current sprint
3. **In Progress**: Tasks currently being worked on
4. **Review**: Tasks completed and awaiting review/testing
5. **Done**: Tasks completed, reviewed, and merged

To add or modify columns:
1. Click "+ Add column" or the three dots on an existing column to edit
2. Enter the column name
3. Click "Create column" or "Save"

## Step 3: Create Milestone Issues

For each milestone in the project_board.md file, create a milestone issue:

1. Go to the "Issues" tab in the repository
2. Click "New issue"
3. Use the milestone name as the title (e.g., "Milestone 1: Project Foundation (Sprint 1-2)")
4. In the description, include the milestone overview from project_board.md
5. Add a "milestone" label
6. Click "Submit new issue"

Repeat for all 6 milestones.

## Step 4: Create User Story Issues

For each user story in the project_board.md file:

1. Go to the "Issues" tab
2. Click "New issue"
3. Use the user story as the title (e.g., "As a developer, I want a well-structured repository so that the project is maintainable and secure")
4. In the description:
   - Include the full user story
   - List all tasks for this user story
   - Reference the related milestone issue (e.g., "Part of #1" where 1 is the milestone issue number)
5. Add a "user-story" label
6. Click "Submit new issue"

## Step 5: Create Task Issues

For each task under a user story:

1. Go to the "Issues" tab
2. Click "New issue"
3. Use the task description as the title (e.g., "Enable branch protection rules for main branch")
4. In the description:
   - Include detailed requirements for the task
   - Reference the parent user story (e.g., "Part of #7" where 7 is the user story issue number)
5. Add appropriate labels (e.g., "task", "backend", "frontend", etc.)
6. Click "Submit new issue"

## Step 6: Add Issues to the Project Board

For each issue:

1. Open the issue
2. In the right sidebar, click "Projects"
3. Select "AgriTrace Development Board" from the dropdown
4. Place the issue in the appropriate column based on its status

Alternatively, from the project board:
1. Click "+ Add cards" in the appropriate column
2. Drag and drop issues from the list that appears

## Step 7: Link PRs to Tasks

When working on a task:

1. Create a feature branch from develop (format: feature/[feature-name])
2. Complete the task with appropriate commits
3. Open a pull request to develop
4. In the PR description, include "Closes #X" where X is the issue number
5. This will automatically link the PR to the issue and close it when merged

## Step 8: Track Progress

As work progresses:

1. Move issues across the board from left to right
2. Update issue status and add comments as needed
3. When a PR is opened, move the related issue to "Review"
4. When a PR is merged, move the related issue to "Done"
5. Document completed features in release notes

## Example Workflow

1. Start with user story "As a developer, I want a well-structured repository"
2. Create task issues for each sub-task
3. Add all issues to the project board in the "Backlog" column
4. Move priority tasks to "To Do"
5. When starting work on a task, move it to "In Progress"
6. Create a PR and link it to the task
7. Move the task to "Review" when the PR is ready
8. After review and merge, move the task to "Done"

## Maintaining the Board

For exemplary project management:

1. Update the board daily
2. Link all PRs to their corresponding tasks
3. Hold regular sprint reviews to assess milestone progress
4. Use the board during team meetings to discuss progress
5. Ensure all work is meticulously tracked through the board

By following this guide, your project board will meet the exemplary criteria in the rubric, showing detailed user stories and tasks for future milestones, meticulous tracking of work, and a clear, professional plan.
