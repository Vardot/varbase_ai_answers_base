# Changelog

All notable changes to the Varbase AI Answers Base (Ask AI) recipe are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.1] - 2026-11-25
### Changed
- Use caret constraints and allow Drupal 11.4 and later and Drupal 12 in Varbase AI Answers Base (Ask AI) ([#3638255](https://git.drupalcode.org/project/varbase_ai_answers_base/-/work_items/3638255)).
- Update the version badge to `1.0.1` in `README.md`.

## [1.0.0] - 2026-11-23
### Changed
- Change the default PHP version to PHP 8.5 in the GitLab CI ([#3638252](https://www.drupal.org/i/3638252)).
- Update the version badge to `1.0.0` in `README.md`.

## [1.0.0-rc1] - 2026-11-14
### Changed
- Update Node.js to `>= 24.0` in `package.json` and the GitLab CI ([#3635698](https://www.drupal.org/i/3635698)).
- Update the version badge to `1.0.0-rc1` in `README.md`.

## [1.0.0-beta2] - 2026-10-29
### Added
- A Claude Code agent and skill for applying and verifying the recipe ([#3633889](https://www.drupal.org/i/3633889)).

### Changed
- Disable Drupal CMS telemetry in CI ([#3633844](https://www.drupal.org/i/3633844)).
- Update the version badge to `1.0.0-beta2` in `README.md`.

## [1.0.0-beta1] - 2026-10-27
### Added
- Automated functional acceptance tests for Ask AI answers and accessibility, run in CI on a fresh Varbase 11 site ([#3633133](https://www.drupal.org/i/3633133)).

### Changed
- Move the documentation to docs.varbase.vardot.com ([#3633029](https://www.drupal.org/i/3633029)).
- Install the Varbase Starter dev line in CI, which carries the search view fix for Drupal CMS Search 2.2.7.
- Update the version badge to `1.0.0-beta1` in `README.md`.

## [1.0.0-alpha1] - 2026-10-24
### Added
- Initialize Varbase AI Answers Base (Ask AI) recipe ([#3632426](https://www.drupal.org/i/3632426)).
### Removed
- The GitHub Actions workflows and the `.github` templates: CI runs on git.drupalcode.org.

[Unreleased]: https://git.drupalcode.org/project/varbase_ai_answers_base/-/compare/1.0.1...1.0.x
[1.0.1]: https://git.drupalcode.org/project/varbase_ai_answers_base/-/compare/1.0.0...1.0.1
[1.0.0]: https://git.drupalcode.org/project/varbase_ai_answers_base/-/compare/1.0.0-rc1...1.0.0
[1.0.0-rc1]: https://git.drupalcode.org/project/varbase_ai_answers_base/-/compare/1.0.0-beta2...1.0.0-rc1
[1.0.0-beta2]: https://git.drupalcode.org/project/varbase_ai_answers_base/-/compare/1.0.0-beta1...1.0.0-beta2
[1.0.0-beta1]: https://git.drupalcode.org/project/varbase_ai_answers_base/-/compare/1.0.0-alpha1...1.0.0-beta1
[1.0.0-alpha1]: https://git.drupalcode.org/project/varbase_ai_answers_base/-/tags/1.0.0-alpha1
