# 10. Coding Standards
All Nix code must be formatted with `nixpkgs-fmt`. The standards enforce strict separation of concerns (e.g., no hardware paths in shared modules) and the use of Nix's module system for configuration.

---

### Git Guidelines

#### Branching Strategy

All work should be done on feature branches. The `main` branch is considered production-ready and should only be updated through pull requests from a `develop` or release branch.

1.  **`main` Branch**: Represents the latest production release. Direct commits are not allowed.
2.  **`develop` Branch**: The primary development branch where all completed features are merged. This should be a stable branch.
3.  **Feature Branches**: All new features and stories should be developed on their own branch.
    *   **Naming Convention**: `feature/<story-id>-<short-description>`
    *   **Example**: `feature/1.1-initialize-project-repository`
4.  **Bugfix Branches**: For non-urgent bug fixes.
    *   **Naming Convention**: `bugfix/<issue-id>-<short-description>`
    *   **Example**: `bugfix/234-fix-login-button`

#### Committing Strategy

We use the [Conventional Commits](https://www.conventionalcommits.org/) specification. This helps in automating changelogs and makes the commit history more readable.

1.  **Format**: `<type>(<scope>): <subject>`
    *   **`<type>`**: `feat` (new feature), `fix` (bug fix), `docs` (documentation), `style` (formatting), `refactor`, `test`, `chore` (build tasks, etc.).
    *   **`<scope>`** (optional): The story ID the commit relates to (e.g., `1.1`, `2.3`).
    *   **`<subject>`**: A concise description of the change.

2.  **Examples**:
    *   `feat(1.1): add initial Nix flake structure`
    *   `fix(auth): resolve issue with incorrect password validation`
    *   `docs: update git branching and commit guidelines`

---