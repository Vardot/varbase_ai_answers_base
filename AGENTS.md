# AGENTS.md

Guidance for AI coding agents working on the Varbase AI Answers (Ask AI) recipe.

This is a **private** recipe on GitHub (`Vardot/varbase_ai_answers_base`), not a drupal.org project. Issues, pull
requests and CI all live on GitHub. Its default branch is `1.0.x`, and it is managed like
[rightup_translate_to_ar](https://github.com/Vardot/rightup_translate_to_ar).

## Before you start

- **`CHANGELOG.md`**: what changed in each release, newest first. Read it before proposing a change.
- **Pull requests and their discussions** on
  [github.com/Vardot/varbase_ai_answers_base](https://github.com/Vardot/varbase_ai_answers_base/pulls): the reasoning behind
  recent changes.
- **Issues** on [github.com/Vardot/varbase_ai_answers_base/issues](https://github.com/Vardot/varbase_ai_answers_base/issues):
  the Problem/Motivation and Proposed resolution for each change.
- **`README.md`**: what was checked, what was not, and the known issues.
- **[Varbase AI Search](https://github.com/Vardot/varbase_ai_search_base)**: this recipe applies it first, and its
  `content_vector` index is what the agent searches.

## When you make a change

- One issue and one pull request per change. The PR says `Closes #<issue>` and ends with the Checkpoints list
  from `.github/pull_request_template.md`.
- Add an entry under `## [Unreleased]` in `CHANGELOG.md`.
- CI must be green before merging: `.github/workflows/ci.yml` lints the repository, then applies the recipe on a
  real Drupal 11.4 site with MariaDB 11.8, after Varbase Search Base, the MariaDB provider, vartheme_bs5 and AI
  Answers, and runs the no-key recipe check.
- CI reads Varbase AI Search with a read-only deploy key: the secret `VARBASE_AI_SEARCH_DEPLOY_KEY` here, and the
  deploy key on `Vardot/varbase_ai_search_base`. Never replace it with a personal token or a key that can write.
- The recipe applies once, because Varbase AI Search's server cannot be created again. Do not add a second apply to
  CI.
- When Canvas or AI Answers changes, the pattern's component versions may change too. Regenerate them and let
  The CI recipe check confirm them before merging.
- No PHP in the repository at all: no `.php`, `.module`, `.install` or `.inc` file. The no-key checks run inline in
  `.github/workflows/ci.yml` (`drush php:eval`), and the lint job fails on any PHP file.
- Never bump the version or tag a release without explicit maintainer approval. Tags are three-segment
  (`1.0.0`) and are never moved once pushed.
