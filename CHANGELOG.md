# Changelog

All notable changes to the clean-apex agent skill will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2026-02-09

### Added

#### Core Functionality
- 3-tier architecture enforcement (entry-point, service, OO layers)
- 15 comprehensive templates covering all architectural layers:
  - Entry-point: REST API, Batch, Trigger handlers
  - Service: Business logic orchestration
  - OO: Domain objects, builders, collections
  - Selector: SOQL query layer
  - Test: Unit and integration test patterns
- Python validator for automated clean-code checking
- 5 focused reference documentation files:
  - Core architecture principles
  - Clean-code testing guidelines
  - Naming conventions and role suffixes
  - Code review checklist
  - Migration guide
- Hook support for automated validation on file changes
- OpenAI agent configuration
- Pattern packs for common scenarios (REST API, Trigger, Batch)
- Sanitized examples demonstrating best practices

#### Documentation & Discoverability
- Comprehensive documentation (Getting Started, FAQ, Troubleshooting, Contributing sections in README)
- references/README.md index with guided reading order and usage scenarios
- Enhanced TEMPLATE_INDEX.md with quick reference table, pattern pack documentation, and usage guidelines
- Comprehensive GLOSSARY.md covering 100+ architecture, testing, and Apex-specific terms
- Glossary integration in README.md with key concept quick links
- Template metadata headers for improved discoverability and self-documentation

#### Platform Support & Distribution
- Platform-specific agent configurations:
  - claude.yaml - Claude Code with full hook support
  - codex.yaml - Codex CLI with auto-detect hooks
  - github-copilot.yaml - GitHub Copilot Agent Skills schema
  - generic.yaml - Universal fallback configuration
- agents/README.md documenting all platform configurations and installation
- .skillignore for distribution optimization (excludes dev artifacts)
- Version tracking and licensing (MIT License)
- CHANGELOG.md following Keep a Changelog format

#### Metadata & Versioning
- Enhanced SKILL.md frontmatter with version, author, keywords, capabilities, platforms
- Version consistency across all configuration files (1.0.0)
- Explicit error handling mode (advisory) in hooks configuration

### Features
- Advisory validation mode (non-blocking feedback)
- Suppression directive support for intentional rule violations
- DML/SOQL layer enforcement
- Naming convention validation
- Code hygiene checks (JavaDoc, test assertions, exception handling)
- Template-based code generation
- Multi-platform agent skill support

### Principles
- Strict separation of concerns (3-tier architecture)
- Dependency injection for testability
- No DML in OO classes (preserve domain purity)
- Semantic naming with role suffixes
- Unit tests for business logic, integration tests for SOQL
- Opinionated guidance to reduce decision fatigue

[Unreleased]: https://github.com/xixiao/clean-apex/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/xixiao/clean-apex/releases/tag/v1.0.0
