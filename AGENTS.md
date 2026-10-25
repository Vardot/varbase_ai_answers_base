# AGENTS.md

Guidance for AI coding agents working on the Varbase AI Answers (Ask AI) recipe.

This is a drupal.org project: [drupal.org/project/varbase_ai_answers_base](https://www.drupal.org/project/varbase_ai_answers_base).
Issues live in its [issue queue](https://www.drupal.org/project/issues/varbase_ai_answers_base) and merge requests on
[git.drupalcode.org](https://git.drupalcode.org/project/varbase_ai_answers_base). Its default branch is `1.0.x`; the
GitHub repository is a mirror and takes no issues or pull requests.

## Before you start

- **Documentation** lives on the Varbase docs site: [docs.varbase.vardot.com](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-answers-base). Keep `README.md` short and link there; add no `docs/` folder.
- **`CHANGELOG.md`**: what changed in each release, newest first. Read it before proposing a change.
- **Issues and merge requests** on drupal.org: the Problem/Motivation, Proposed resolution and the reasoning
  behind recent changes.
- **[Varbase AI Search](https://www.drupal.org/project/varbase_ai_search_base)**: this recipe applies it first, and its
  `content_vector` index is what the agent searches.

## When you make a change

- One drupal.org issue and one issue-fork merge request per change, titled `<type>: #<issue> Summary`. The MR
  description ends with the Checkpoints list from `.gitlab/merge_request_templates/default.md`.
- CI must be green before merging: `.gitlab-ci.yml` on git.drupalcode.org validates `composer.json` and lints
  every YAML file.
- No PHP in the repository at all: no `.php`, `.module`, `.install` or `.inc` file.
- All configuration lives in `recipe.yml` and the recipe's own `config/`, never in `config/install` or `config/optional`.
- Add an entry under `## [Unreleased]` in `CHANGELOG.md`.
- The recipe applies once, because Varbase AI Search's server cannot be created again. Do not add a second apply to
  CI.
- When Canvas or AI Answers changes, the pattern's component versions may change too. Regenerate them and let
  The CI recipe check confirm them before merging.
- Never bump the version or tag a release without explicit maintainer approval. Tags are three-segment
  (`1.0.0`) and are never moved once pushed.
