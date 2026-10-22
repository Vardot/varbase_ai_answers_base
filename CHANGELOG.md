# Changelog

All notable changes to the Varbase AI Answers (Ask AI) recipe are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]
### Changed
- The Ask AI pattern moves out of `config/` into a recipe of its own, `patterns/ask_ai`, so this recipe applies on a site
  whose theme is not Vartheme BS5 (the pattern is built from `sdc.vartheme_bs5.section`, and an apply on another theme
  stopped on it before anything was applied). On a Vartheme BS5 site, apply it with `ddev drush recipe
  ../recipes/varbase_ai_answers_base/patterns/ask_ai`. CI applies it after this recipe and still checks it (#8).

## [1.0.2] - 2026-10-12
### Changed
- Removed `tests/verify.php`: the repository now holds no PHP file. CI runs the same no-key checks inline
  (`drush php:eval` in `.github/workflows/ci.yml`), and the lint job fails on any `.php`, `.module`, `.install` or
  `.inc` file (#7).

### Checked
- CI on 1.0.x (https://github.com/Vardot/varbase_ai_answers_base/actions/runs/38238494309): the lint job found no PHP file, the recipe applied twice, the inline
  check printed `RESULT: PASS` and the functional tests passed.

## [1.0.1] - 2026-10-11
### Added
- Functional tests in `tests/features`, run in CI after `tests/verify.php`: Playwright and Cucumber
  through `@vardot/varbase-e2e`, in Chromium, against the Varbase 11 site CI builds. They check the admin pages
  the recipe sets up.
### Changed
- Renamed the repository and the package from `varbase_ai_answers` to `varbase_ai_answers_base`
  (`vardot/varbase_ai_answers_base`). The old GitHub URL redirects. The agent id (`varbase_ai_answers`), the AI
  Answers wiring and the Ask AI pattern are unchanged.
- Require and apply `vardot/varbase_ai_search_base`, the renamed Varbase AI Search.

## [1.0.0] - 2026-10-08
### Added
- The recipe: applies Varbase AI Search, then adds the `varbase_ai_answers` retrieval agent with its RAG search
  tool locked to the `content_vector` index, AI Answers wired to the agent, `use ai answers` for anonymous and
  authenticated users, and the Ask AI (cited answers) Canvas pattern.
- `tests/verify.php`: checks the modules, the `content_vector` index, the agent and its lock, the AI Answers
  wiring, the permissions, and the Ask AI pattern with every component at the version it carries. It needs no AI
  key.
- GitHub Actions CI: lint, then a real Varbase 11 site (`drupal/varbase_project` `11.0.x-dev` with Varbase's curated
  patches, installed from Varbase Starter) on MariaDB 11.8, which is also the vector database, with the AI
  module's Echo test provider as the default embeddings model. It applies Varbase Search Base first, sets the
  provider and the defaults, installs vartheme_bs5 as the default theme, enables AI Answers, applies the recipe
  once and runs `tests/verify.php`. Varbase AI Search is read with a read-only deploy key
  (`VARBASE_AI_SEARCH_DEPLOY_KEY`).
- README in the Varbase AI recipe style, `AGENTS.md`, `LICENSE`, `logo.png`, composer metadata, and the Vardot
  issue and pull request templates.

### Changed
- Require `vardot/varbase_ai_search: ^1.0`, so the 1.0.0 tag resolves.

[Unreleased]: https://github.com/Vardot/varbase_ai_answers_base/compare/1.0.2...1.0.x
[1.0.2]: https://github.com/Vardot/varbase_ai_answers_base/compare/1.0.1...1.0.2
[1.0.1]: https://github.com/Vardot/varbase_ai_answers_base/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/Vardot/varbase_ai_answers_base/releases/tag/1.0.0
