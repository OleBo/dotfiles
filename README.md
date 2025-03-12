# My Personal Dotfiles Managed with [chezmoi](https://www.chezmoi.io)

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)
[![GitHub stars](https://img.shields.io/github/stars/olebo/dotfiles.svg)](https://github.com/olebo/dotfiles/stargazers)
![Acceptance](https://github.com/olebo/dotfiles/actions/workflows/acceptance-tests.yaml/badge.svg)
![Linter](https://github.com/olebo/dotfiles/actions/workflows/linters.yaml/badge.svg)
![Renovate](https://github.com/olebo/dotfiles/actions/workflows/renovate.yaml/badge.svg)
![ToDo](https://github.com/olebo/dotfiles/actions/workflows/todo2github-issues.yaml/badge.svg)

[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/olebo/dotfiles)

[https://github.com/kitos9112/dotfiles]

This repository contains my personal dotfiles, managed using [chezmoi](https://www.chezmoi.io). While these configurations are optimized for my own workflow, you’re welcome to adapt and use any part of them to boost your productivity.

---

## Table of Contents

- [Supported Platforms](#supported-platforms)
- [Installation](#installation)
  - [Using the Convenience Script](#using-the-convenience-script)
  - [Manual Installation with Git](#manual-installation-with-git)
  - [Installation via chezmoi](#installation-via-chezmoi)
- [Testing](#testing)
  - [Running Tests Locally](#running-tests-locally)
  - [Continuous Integration](#continuous-integration)
- [Chezmoi Scripts](#chezmoi-scripts)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [About](#about)
- [License](#license)
- [Managing pre-commit hooks](#managing-pre-commit-hooks)
- [Gitpod development environments](#gitpod-development-environments)
- [Set environment variables](#set-environment-variables)
- [Set souce state directory](#set-souce-state-directory)

---

## Supported Platforms

This setup has been tested on multiple operating systems and Linux distributions, including:

- **Fedora:** 
- **Ubuntu:** 
- **macOS**

Docker containers are used for testing across these platforms to ensure compatibility and reliability.

---

## Installation

You have several options to install and apply these dotfiles on your system.

### Using the Convenience Script

If you don’t already have chezmoi installed, run the following one-liner to download and execute the install script:

```bash
# Using curl
sh -c "$(curl -fsSL https://raw.githubusercontent.com/olebo/dotfiles/master/install)"

# OR Using wget
sh -c "$(wget -qO- https://raw.githubusercontent.com/olebo/dotfiles/master/install)"
```

### Manual Installation with Git

Clone the repository and execute the installation script from the repository’s root:

```bash
git clone https://github.com/olebo/dotfiles.git
cd dotfiles
sh install
```

### Installation via chezmoi

If you prefer using chezmoi directly, you can initialize and apply the dotfiles with a single command:

```bash
chezmoi init --apply --verbose https://github.com/olebo/dotfiles.git
```

---

## Testing

This repository includes tests to ensure that the dotfiles and associated scripts function as expected across different environments.

### Running Tests Locally

There are multiple ways to run the tests:

#### Using Taskfile

If you have [Task](https://taskfile.dev) installed, you can run the tests using the preconfigured task:

```bash
task test
```

This command leverages the tasks defined in the `Taskfile.yaml` to run the tests found in the `tests` directory. It provides an easy way to execute the suite of tests that ensure cross-platform compatibility.

#### Manual Execution

Alternatively, you can navigate to the `tests` folder and run individual test scripts directly. For example, if there's a test runner script provided:

```bash
cd tests
./run_tests.sh
```

Check the `tests` directory for any README or instructions detailing available test scripts and options.

### Continuous Integration

The repository is integrated with GitHub Actions to automatically run tests on every push and pull request. These CI workflows help ensure that any changes do not break the configuration on any of the supported platforms. You can view the current status of these tests in the [Actions tab](https://github.com/olebo/dotfiles/actions) of the repository.

---

## Chezmoi Scripts

This repository leverages chezmoi to manage configuration files. Custom scripts are organized into specific categories based on when they should run:

- **`run` Scripts:** Executed every time you run `chezmoi apply`.
- **`run_once` / `run_onchange` Scripts:** Executed only once or when changes are detected.

These scripts are stored in a dedicated directory to keep the target system clean.

---

## Security Considerations

When managing dotfiles, especially if they include a local `.git` folder or other sensitive information, it’s important to avoid exposing confidential data. This repository:

- **Avoids exposing sensitive git history:** Uses scripts (e.g., `scripts/00_run_once/run_once_100-extras.zsh.tmpl`) to safely clone or update third-party repositories.
- **Emphasizes cautious configuration:** Regular updates and CI workflows help ensure that changes do not inadvertently compromise security.

---

## Contributing

While these dotfiles are primarily for personal use, contributions that enhance portability, security, or overall usability are welcome. Feel free to fork the repository and submit pull requests with improvements or fixes.

---

## About

These dotfiles are designed for a flexible and reproducible setup across multiple environments. They have been developed and maintained with continuous integration via GitHub Actions to ensure consistent behavior on supported platforms.

**Topics Covered:** macOS, Linux, Shell, Dotfiles, zsh, Ubuntu, Fedora, M1, chezmoi

---

## License

This repository is distributed under the [MIT license](./LICENSE).

---

Feel free to customize and adapt these configurations to suit your own development environment!

---

## Managing pre-commit hooks

The `.pre-commit-config.yaml` file configures the [pre-commit](https://pre-commit.com/) framework to automatically run a series of code quality and security checks before commits are finalized. Here’s a breakdown of what each section does:

---

### Global Settings

- **fail_fast: false**  
  This setting ensures that even if one hook fails, the rest of the hooks will still run. This is useful to catch as many issues as possible in a single commit run.

- **ci Section**  
  This part is configured to help with continuous integration. It defines:
  - **autofix_commit_msg:** A commit message template for auto fixes generated by pre-commit.com hooks.
  - **autofix_prs:** Automatically create pull requests for fixes.
  - **autoupdate_commit_msg:** A commit message template for when hooks are auto-updated.
  - **autoupdate_schedule:** Sets a weekly schedule for automatically updating hooks.
  - **submodules: false:** Specifies that submodules are not considered in the update process.

---

### Hook Repositories

The `repos` list defines external repositories that provide various hooks. Each repository is pinned to a specific revision to ensure consistency.

1. **YAML Linting**
   - **Repository:** [adrienverge/yamllint](https://github.com/adrienverge/yamllint.git)  
   - **Revision:** `v1.35.1`  
   - **Hook:** `yamllint`  
   - **Arguments:** It uses a custom configuration file (`.github/linters/.yamllint.yaml`) to enforce YAML formatting and syntax rules.

2. **General Pre-commit Hooks**
   - **Repository:** [pre-commit/pre-commit-hooks](https://github.com/pre-commit/pre-commit-hooks)  
   - **Revision:** `v5.0.0`  
   - **Hooks Included:**
     - `trailing-whitespace`: Removes trailing whitespace.
     - `fix-byte-order-marker`: Fixes byte order markers in files.
     - `mixed-line-ending`: Normalizes line endings.
     - `check-added-large-files`: Prevents accidentally committing files that exceed 2MB (configured via `--maxkb=2048`).
     - `check-merge-conflict`: Detects unresolved merge conflict markers.
     - `check-executables-have-shebangs`: Ensures that executable scripts have proper shebang lines.

3. **Forbid CRLF Line Endings**
   - **Repository:** [Lucas-C/pre-commit-hooks](https://github.com/Lucas-C/pre-commit-hooks)  
   - **Revision:** `v1.5.5`  
   - **Hook:** `forbid-crlf`  
   - **Purpose:** Enforces consistent Unix-style LF line endings by forbidding Windows-style CRLF.

4. **Fixing Smart Quotes**
   - **Repository:** [sirosen/fix-smartquotes](https://github.com/sirosen/fix-smartquotes)  
   - **Revision:** `0.2.0`  
   - **Hook:** `fix-smartquotes`  
   - **Purpose:** Automatically converts “smart quotes” to standard quotes to avoid issues in code and configuration files.

5. **Secret Detection**
   - **Repository:** [gitleaks/gitleaks](https://github.com/gitleaks/gitleaks)  
   - **Revision:** `v8.24.0`  
   - **Hook:** `gitleaks`  
   - **Purpose:** Scans commits for secrets and sensitive information to prevent accidental exposure.

6. **Renovate Configuration Validation**
   - **Repository:** [renovatebot/pre-commit-hooks](https://github.com/renovatebot/pre-commit-hooks)  
   - **Revision:** `39.177.1`  
   - **Hook:** `renovate-config-validator`  
   - **Purpose:** Validates the configuration files for [Renovate](https://docs.renovatebot.com), a tool used to automatically update dependencies.

---

### Summary

In essence, this configuration file helps maintain code quality and consistency by running checks for common formatting issues (like trailing whitespace and improper line endings), validating configuration files (YAML linting, Renovate config), and enhancing security (detecting secrets). The automatic CI settings further streamline updates and auto-fix processes to keep the repository in a healthy state.

This setup ensures that every commit is pre-vetted for potential issues, helping to maintain a high standard of code quality and security across the repository.

---

## Gitpod development environments

The `.gitpod.yml` file is a configuration file for [Gitpod](https://www.gitpod.io/), which is an online development environment. In this repository, it’s used to pre-configure the workspace, specifically to install a set of VS Code extensions that enhance shell scripting and bash development. Here’s what it does:

---

### VS Code Extensions

Under the `vscode` key, the file lists several extensions to be automatically installed when the Gitpod workspace is launched:

- **timonwong.shellcheck@0.12.2**  
  Provides linting and diagnostics for shell scripts using [ShellCheck](https://www.shellcheck.net/).

- **foxundermoon.shell-format@7.0.1**  
  Automatically formats shell scripts, ensuring consistent styling and formatting.

- **mads-hartmann.bash-ide-vscode@1.11.0**  
  Adds Bash language support including features like autocompletion, code navigation, and error checking by integrating a Bash language server.

- **rogalmic.bash-debug@0.3.9**  
  Enables debugging capabilities for Bash scripts, allowing you to set breakpoints and inspect your shell scripts in real time.

---

### Overall Purpose

By defining these extensions, the `.gitpod.yml` file ensures that anyone opening the repository in Gitpod gets an optimized environment tailored for working with shell scripts and dotfiles. This setup improves productivity by:

- **Ensuring Code Quality:** Automated linting and formatting help maintain high code standards.
- **Enhanced Developer Experience:** Features like autocompletion, diagnostics, and debugging tools streamline development.
- **Consistency:** Every developer gets the same development tools, reducing setup time and configuration differences.

In summary, the file helps create a ready-to-use, consistent Gitpod workspace that is especially beneficial for editing and managing the shell scripts and configuration files found in the dotfiles repository.

---

## Set environment variables

The `.env` file is used to set environment variables that scripts in the repository can reference during execution. In this particular case, it exports a `GITHUB_TOKEN` variable:

```bash
export GITHUB_TOKEN=op://Private/xn6s6f7wujaosvsr2fitieyxre/Security/DeveloperPAT
```

### What This Does:

- **Sets a GitHub Token:**  
  It assigns a token (used for authenticating with GitHub’s API or for git operations that require authentication) to the environment variable `GITHUB_TOKEN`.

- **Secure Reference:**  
  The value `op://Private/...` suggests that the token is managed through a secrets management tool (likely the 1Password CLI). This way, the actual sensitive token is securely referenced rather than stored directly in plaintext within the repository.

### How It’s Typically Used:

- **Script Authentication:**  
  Various scripts or automated tasks (e.g., updating dotfiles, cloning repositories, or triggering GitHub Actions) can read this environment variable to authenticate with GitHub without manual intervention.

- **Configuration Management:**  
  Using a `.env` file to manage sensitive credentials is a common pattern, as it allows for easy configuration and switching of tokens or other secrets across different environments (development, CI, production, etc.).

In summary, the `.env` file in this repository is a simple mechanism for securely injecting a GitHub authentication token into the environment, ensuring that any automated processes can interact with GitHub in a secure and consistent manner.

---

## Set souce state directory

The `.chezmoiroot` file tells chezmoi where the root of your dotfiles source state is located. In this repository, it is [.home]:

```bash
home
```

### What This Means

- **Source State Directory:**  
  Chezmoi uses this file to determine which directory in the repository represents the base directory for your configuration files. In this case, it tells chezmoi to use the `home` folder as the root.

- **Mapping to the Home Directory:**  
  When you run `chezmoi apply`, it will take the files and directories inside the `home` folder and deploy them into your actual home directory (or another target directory if configured otherwise).

- **Organization:**  
  This approach helps keep the repository organized by clearly separating the files that are meant to be applied to the home directory from other project files (like CI configurations or scripts).

In summary, `.chezmoiroot` with its content `home` ensures that chezmoi knows where to find the dotfiles to apply, maintaining a clear mapping between your repository structure and your system’s home directory.

---
