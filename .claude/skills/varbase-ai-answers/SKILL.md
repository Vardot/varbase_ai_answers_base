---
name: varbase-ai-answers
description: "Apply, repair and verify Varbase AI Answers (Ask AI) on a Varbase 11 site: Ask AI: a public question box with cited answers from the site's own content (Varbase AI Answers Base). Install and apply commands, inputs, config, post-apply steps, browser checks, traps and versions, read from the recipe code. Use when adding, fixing or checking Varbase AI Answers (Ask AI)."
---

# Varbase AI Answers (Ask AI)

Read from `recipe.yml`, `composer.json`, README, CHANGELOG and `git log` at the latest tag, 28 October 2026. Re-check versions on drupal.org before relying on them. For the full Varbase AI apply order, see the Varbase AI recipes docs page.

## Recipes

| Recipe | Latest | Stability | Require |
|---|---|---|---|
| `varbase_ai_answers_base` | 1.0.0-beta1 | beta | `drupal/varbase_ai_answers_base:~1` |

Docs (the code wins where they differ):
- https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-answers-base

## What it does

- Applies `varbase_ai_search_base`, installs `ai_agents`, `ai_answers`. Creates agent `ai_agents.ai_agent.varbase_ai_answers` locked to the `content_vector` index, wires `ai_answers.agents`, grants `use ai answers` to anonymous and authenticated, and packages the Question, Answer and Sources blocks as an "Ask AI" Canvas pattern built from Vartheme BS5 components.
- Composer: `ai ^1.4`, `ai_agents ^1.3`, `ai_answers ^1.0@beta`, `canvas ^1.12`, `varbase_ai_search_base ^1.0`. No inputs.

## Apply

All commands in DDEV, from the project root; recipes are applied from the docroot path `../recipes/<name>`. Take a snapshot first: `ddev snapshot --name before-varbase-ai-answers`. Add each recipe to `extra.drupal-recipe-unpack.ignore` in `composer.json` before requiring it (read the list first: `composer config --json` replaces it).

```bash
ddev composer require drupal/varbase_ai_answers_base:~1
ddev drush en ai_answers -y && ddev drush cr      # BEFORE the apply
ddev drush recipe ../recipes/varbase_ai_answers_base -y
ddev drush search-api:index content_vector
ddev drush cr
```

Needs a vector database recipe applied first and its provider set as the default.

## After the apply

- Drop the "Ask AI" pattern onto a Canvas page (for example `/ask-ai`).
- The search results block's view modes can be reset by the AI recipes: restore them with `drush cset views.view.search display.<display>.display_options...view_modes.entity:node '{...}' --input-format=yaml` with the site's own modes.
- Attach the guardrail sets to the agent (see `varbase-ai-safety`).

## Verify

- `ddev drush cget ai_agents.ai_agent.varbase_ai_answers`.
- As an anonymous visitor: get a session token, POST JSON `{"agent":"varbase_ai_answers","question":"..."}` to `/ai-answers/question`; a good answer has `answer.references`.
- In a browser, ask a question whose answer is on the site: numbered citations and source cards show.

Test as a real editor or visitor, not user 1: a superuser bypasses permissions.

## Traps

- Canvas makes the AI Answers block components only outside a recipe apply: enable `ai_answers` and `cr` first, or the apply stops before doing anything.
- The pattern is built from `sdc.vartheme_bs5.section`: on another theme place the three AI Answers blocks yourself.
- No language filter; each answer is a paid model call.

## History

Started 22 Oct 2026, 1.0.0-alpha1 24 Oct, 1.0.0-beta1 27 Oct (functional tests #3633133).
