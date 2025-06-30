# Contributing to AgriTrace

Thank you for considering contributing to AgriTrace! This document provides guidelines and instructions for contributing to the project.

## Code of Conduct

By participating in this project, you agree to abide by our Code of Conduct. Please read it before contributing.

## How Can I Contribute?

### Reporting Bugs

- Check if the bug has already been reported in the Issues section
- Use the bug report template when creating a new issue
- Include detailed steps to reproduce the bug
- Include screenshots if applicable
- Specify your environment (OS, browser, etc.)

### Suggesting Features

- Check if the feature has already been suggested in the Issues section
- Use the feature request template when creating a new issue
- Explain the problem your feature would solve
- Describe the solution you'd like to see

### Pull Requests

1. Fork the repository
2. Create a new branch from `develop` (not `main`)
3. Make your changes
4. Add or update tests as necessary
5. Update documentation as necessary
6. Ensure all tests pass
7. Submit a pull request to the `develop` branch

## Development Workflow

### Git Workflow

We follow a Git Flow-inspired workflow:

1. `main` branch contains production-ready code
2. `develop` branch is the integration branch for features
3. Feature branches should be created from `develop`
4. Use descriptive branch names: `feature/add-user-authentication`, `bugfix/login-error`

### Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

Types include:
- `feat`: A new feature
- `fix`: A bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code changes that neither fix bugs nor add features
- `test`: Adding or updating tests
- `chore`: Changes to the build process or tools

### Code Style

- **Backend (Python)**: Follow PEP 8 and use flake8/black for linting/formatting
- **Frontend (JavaScript/React)**: Follow Airbnb JavaScript Style Guide and use ESLint/Prettier

## Setting Up Development Environment

See the README.md files in the repository root, backend, and frontend directories for detailed setup instructions.

## Testing

- Write tests for all new features and bug fixes
- Ensure all tests pass before submitting a pull request
- Backend tests use pytest
- Frontend tests use Jest and React Testing Library

## Documentation

- Update documentation when adding or changing features
- Document all public APIs, components, and functions
- Keep README.md and other documentation up to date

## Review Process

1. All pull requests require at least one review
2. CI checks must pass before merging
3. Reviewers may request changes before approving
4. Once approved and CI checks pass, a maintainer will merge the PR

## Questions?

If you have any questions, feel free to open an issue or contact the maintainers directly.

Thank you for contributing to AgriTrace!
