# AgriTrace Video Demonstration Sequence

This document outlines the exact sequence to follow for the 10-minute video demonstration of the AgriTrace continuous deployment pipeline.

## Stage 1: Initial State (1-2 minutes)

1. Start by showing your browser with the currently deployed production application:
   - Navigate to https://agritrace-prod.eastus.azurecontainer.io
   - Show the application is functional by navigating through a few screens
   - Demonstrate a key feature (e.g., farm management or product traceability)

2. Clearly state your name and the purpose of the demonstration:
   - "Hello, my name is [Your Name]. I'll be demonstrating the fully automated continuous deployment pipeline for the AgriTrace application."

## Stage 2: Code Modification (2-3 minutes)

1. Open your code editor and navigate to a visible UI component:
   - For example, open `frontend/src/components/Header.js` or a similar file
   - Make a small but noticeable change (e.g., modify the header text or color)

2. Commit the change using Conventional Commits standard:
   ```
   git add .
   git commit -m "feat(ui): update header text for improved clarity"
   ```

3. Create and push to a new feature branch:
   ```
   git checkout -b feature/demo-ui-enhancement
   git push -u origin feature/demo-ui-enhancement
   ```

4. Show the commit in your GitHub repository:
   - Navigate to your repository on GitHub
   - Show the newly created branch and commit

## Stage 3: Staging Deployment (2-3 minutes)

1. Create a pull request to merge into the develop branch:
   - On GitHub, create a new PR from feature/demo-ui-enhancement to develop
   - Add an appropriate title and description
   - Create the pull request

2. While the pipeline executes, explain each stage:
   - Build process: "The workflow first builds the application and runs tests..."
   - Testing procedures: "Next, it runs both backend and frontend tests..."
   - Security scanning: "Then it performs security scanning on dependencies and container images..."
   - Show the GitHub Actions workflow running in real-time

3. Once the pipeline completes, demonstrate the change on the staging URL:
   - Navigate to https://agritrace-staging.eastus.azurecontainer.io
   - Show that your UI change has been automatically deployed
   - Point out the staging environment banner or indicator

## Stage 4: Production Release (2-3 minutes)

1. Merge changes into the main branch:
   - Create a new PR from develop to main
   - Show the approval process
   - Merge the PR to trigger the production deployment

2. Show the manual approval step for production deployment:
   - Navigate to GitHub Actions
   - Show the approval step waiting for confirmation
   - Approve the deployment

3. Explain the monitoring dashboard and alarm configuration:
   - Navigate to Azure Portal
   - Show the AgriTrace monitoring dashboard
   - Explain the metrics being tracked
   - Point out the configured alarms and their triggers

## Stage 5: Verification (1-2 minutes)

1. Refresh the production URL to confirm live deployment:
   - Navigate to https://agritrace-prod.eastus.azurecontainer.io
   - Show that your UI change has been deployed to production

2. Show updated CHANGELOG.md entry:
   - Open the CHANGELOG.md file in your repository
   - Show the automatically generated entry for your deployment

3. Conclude with a summary:
   - "As demonstrated, our CI/CD pipeline provides fully automated deployment from code change to production"
   - "The pipeline includes comprehensive security scanning, testing, and monitoring"
   - "This enables us to deliver changes quickly and safely to our users"

## Technical Requirements Checklist

- [ ] High-quality screen recording with clear audio
- [ ] Minimum 720p resolution
- [ ] Maximum 10 minutes duration
- [ ] Maximum file size: 500MB
- [ ] Supported format: MP4, MOV, or AVI
- [ ] Link included in repository README.md
