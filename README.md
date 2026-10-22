[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

# Varbase AI Answers Base (Ask AI)
[![Varbase AI Answers Base (Ask AI)](https://img.shields.io/badge/Varbase%20AI%20Answers%20Base%20%28Ask%20AI%29-1.0.x--dev-0d6efc?labelColor=001d38&style=flat-square)](https://www.drupal.org/project/varbase_ai_answers_base)

An **opt-in** Drupal recipe that adds "Ask AI" to a Varbase 11 site: a public question box that answers
in plain language with numbered citations and source cards, grounded only in the site's own content.
The Drupal AI Demo calls the same feature Ask AI. This is the Varbase version of it.

It builds on [Varbase AI Search](https://www.drupal.org/project/varbase_ai_search_base), which owns the vector
server and index and is applied first. This recipe adds what answers from it: the retrieval agent, AI
Answers, the permissions and the Canvas pattern that holds the three blocks.

Varbase never applies this by default. Nothing here runs unless somebody applies it on purpose.

**Experimental.** `ai_search` declares `lifecycle: experimental` and AI Answers is beta, so this stack is not
covered by the Drupal security advisory policy. Of the three vector database providers, only MariaDB has a stable
release.

There is **no custom PHP and no custom shell code** in the recipe. Its no-key checks run inline in CI, so the repository holds no PHP file at
all.

## What it adds

| Where | Change |
|---|---|
| [Varbase AI Search](https://www.drupal.org/project/varbase_ai_search_base) | Applied first: Varbase Search Base, then the `content_vector` server and index (every node and Canvas page, published only, all languages). |
| AI Agents | `Varbase Ask AI` (`varbase_ai_answers`): searches before answering, answers only from retrieved content, cites inline, replies in the visitor's language. The `ai_search:rag_search` tool is forced to the `content_vector` index so a prompt can never point it elsewhere. |
| AI Answers | The agent is enabled for answers, with feedback on, a one-hour conversation and four history turns for follow-ups. |
| Permissions | `use ai answers` for anonymous and authenticated users: the question endpoint is permission-gated and the module grants nothing by default. |
| Canvas | An **Ask AI (cited answers)** pattern: a vartheme_bs5 section holding the Question, Answer and Sources blocks, already wired to each other. Classic Block Layout is not used, because every Varbase theme renders its pages through Drupal Canvas, where block placements never render. It is its own small recipe, `patterns/ask_ai`, not part of this one: it is built from Vartheme BS5 components, so an apply on any other theme would fail on it. Apply it on a Vartheme BS5 site (see Install and apply). |

Content is re-embedded on save and by cron. After changing the chunk settings or the embeddings model:
`search-api:clear` then `search-api:index`.

## Requirements

- Drupal core `^11.4`, Varbase 11
- [`drupal/ai`](https://www.drupal.org/project/ai) `^1.4`
- [`drupal/ai_agents`](https://www.drupal.org/project/ai_agents) `^1.3`
- [`drupal/ai_answers`](https://www.drupal.org/project/ai_answers) `^1.0@beta`. The pattern carries the component
  versions of AI Answers 1.0.0-beta4.
- [`drupal/canvas`](https://www.drupal.org/project/canvas) `^1.12`
- [`drupal/varbase_ai_search_base`](https://www.drupal.org/project/varbase_ai_search_base) `^1.0`, applied first
- The vartheme_bs5 theme, whose section component holds the pattern
- A default chat model and a default embeddings model (Varbase AI Base sets them, under Configuration > AI > AI
  settings), and a default vector database provider from one of the three [vector database recipes](#vector-databases)

## Install and apply

Start from a Varbase 11 build with Varbase AI Base applied, then run these commands from the project folder. They
are the whole procedure.

```bash
# 1. Fetch the recipes.
#    The ignore line also covers the vector database recipe of step 2.
ddev composer config --json extra.drupal-recipe-unpack.ignore '["drupal/varbase_ai_search_base", "drupal/varbase_ai_answers_base", "drupal/varbase_ai_vdb_milvus", "drupal/varbase_ai_vdb_mariadb"]'
ddev composer require drupal/varbase_ai_answers_base:1.0.x-dev
#    Enable AI Answers now, outside the recipe, and rebuild caches: Canvas generates the AI Answers
#    block components the Ask AI pattern needs only outside a recipe apply.
ddev drush en ai_answers -y
ddev drush cr
```

**Step 2: a vector database. Run the commands of ONE of these three recipes.** Each one installs its provider,
connects it and makes it the site default, which Varbase AI Search reads. Varbase AI Search names its vector
database `varbase_ai_search`, so each block ends with the one thing that name needs. The remote setups (Zilliz
Cloud, a separate server, Upsun) are in each recipe's README, linked in each heading.

**2a. Milvus**, local in DDEV. [README](https://www.drupal.org/project/varbase_ai_vdb_milvus)

```bash
ddev composer require drupal/varbase_ai_vdb_milvus:1.0.x-dev
cp recipes/varbase_ai_vdb_milvus/ddev/docker-compose.milvus.yaml .ddev/
ddev restart
ddev drush cr
ddev drush recipe ../recipes/varbase_ai_vdb_milvus
ddev drush cr
ddev drush cset ai.settings default_vdb_provider milvus -y
# A Milvus database called varbase_ai_search must exist. If the call is refused, wait for the milvus
# container to be healthy and run it again.
ddev exec 'curl -s http://milvus:19530/v2/vectordb/databases/create -X POST -H "Content-Type: application/json" -d "{\"dbName\":\"varbase_ai_search\"}"'
```

**2b. MariaDB**, the site's own database. Needs MariaDB 11.7 or later: DDEV runs 11.8, and the Varbase Upsun
template runs 10.11 until its database service is upgraded (read the README first: a downgrade deletes the
data). [README](https://www.drupal.org/project/varbase_ai_vdb_mariadb)

Apply Varbase Search Base **before** the MariaDB provider is installed. A Varbase site already has it applied. On
any other site, apply it first, because the provider crashes on the keyword index it sets up (see
[Known issues](#known-issues)):

```bash
ddev drush cr
ddev drush recipe ../recipes/varbase_search_base
ddev drush cr
```

Then:

```bash
ddev composer require drupal/varbase_ai_vdb_mariadb:1.0.x-dev
ddev drush cr
ddev drush recipe ../recipes/varbase_ai_vdb_mariadb
ddev drush cr
ddev drush cset ai.settings default_vdb_provider mariadb -y
# A MariaDB database called varbase_ai_search must exist and the site's user needs access to it. On DDEV the
# root account is root/root. Elsewhere a database administrator does this.
ddev exec "mysql -hdb -uroot -proot -e \"CREATE DATABASE IF NOT EXISTS varbase_ai_search; GRANT ALL PRIVILEGES ON varbase_ai_search.* TO 'db'@'%'; FLUSH PRIVILEGES;\""
```

All three were tested on 5 October 2026 by running each recipe's own test with the `varbase_ai_search` name.

**Steps 3 to 5:**

```bash
# 3. The Ask AI recipe, in ONE run: Varbase AI Search (the vector server and index), the retrieval
#    agent, AI Answers, the permissions and the Canvas pattern.
ddev drush recipe ../recipes/varbase_ai_answers_base


# 5. Embed the content. One embeddings call per chunk: review the provider pricing first.
ddev drush search-api:index content_vector
ddev drush cr
```

On a Vartheme BS5 site, apply the **Ask AI (cited answers)** pattern. It is built from Vartheme BS5 components, so it is
a recipe of its own, and this one leaves it out: a site on another theme (for example Vartheme BS5 Vardoc) is not stopped
by it, and builds its own page from the three blocks instead.

```bash
ddev drush recipe ../recipes/varbase_ai_answers_base/patterns/ask_ai
ddev drush cr
```

Then open any Canvas page in the editor, insert the **Ask AI (cited answers)** pattern from the
Patterns panel, and publish.

The apply in step 3 runs once: Varbase AI Search's `setupVdbServerWithDefaults` action creates the vector server
and cannot update it, so a second apply stops with "Could not save the configuration". To apply again, delete the
`content_vector` index and server first (Configuration > Search and metadata > Search API).

Step 3 takes the path relative to the Drupal
root, which is why it starts with `../`. The ignore line keeps the recipes locked packages: without it core's
recipe-unpack plugin moves a recipe's dependencies into the project's `composer.json` on require and drops the
recipe itself, so a fresh `composer install` elsewhere has the modules but not the recipe.

## The Ask AI pattern and Canvas

`ai_answers` is enabled before the apply because Canvas generates the `canvas.component.block.ai_answers_*`
entities the pattern needs only outside a recipe apply (its hook returns early while config is syncing).

Canvas validates every `component_version` in the pattern against those entities on import. The versions depend
on Canvas and on AI Answers. The pattern carries the ones a Varbase 11 site generates with Canvas 1.12 and AI
Answers 1.0.0-beta4, as checked in CI:

| Block | Version |
|---|---|
| Question | `e112ef71b463df69` |
| Answer | `a094ec25546481d2` |
| Sources | `92430e1fd46de22b` |

The hash changed between Canvas 1.10 and 1.12, so `composer.json` requires `drupal/canvas ^1.12`. A site whose
components were generated differently can show other versions; the recipe check reports the ones it found. A site on an older Canvas needs its lock refreshed first. A future
Canvas or AI Answers that changes the versions again needs the pattern regenerated:

```bash
ddev drush cget canvas.component.block.ai_answers_question active_version
ddev drush cget canvas.component.block.ai_answers_answer active_version
ddev drush cget canvas.component.block.ai_answers_sources active_version
```

## Check it on the site

```bash
ddev drush search-api:status content_vector            # must reach 100%
ddev drush search-api:search content_vector "mobile first websites"

# The endpoint, as an anonymous visitor
U=https://<project>.ddev.site
T=$(curl -sk -c jar -b jar $U/session/token)
curl -sk -c jar -b jar -X POST $U/ai-answers/question \
  -H "Content-Type: application/json" -H "X-CSRF-Token: $T" \
  -d '{"agent":"varbase_ai_answers","question":"Is Varbase a good fit for mobile-first websites?"}'
```

A good answer carries `answer.references` with a URL per source. The no-answer message with an empty
list means retrieval returned nothing: check the index status, the vector provider settings, and the
AI log.

## Vector databases

Ask AI works with any vector database provider. Each of these has its own recipe, managed on its own, that
installs the provider, connects it, and has a CI recipe check that needs no AI key. Remote setups (Zilliz
Cloud, a separate server, Upsun) are in each recipe's own README.

| | Milvus | MariaDB |
|---|---|---|
| Recipe | [varbase_ai_vdb_milvus](https://www.drupal.org/project/varbase_ai_vdb_milvus) | [varbase_ai_vdb_mariadb](https://www.drupal.org/project/varbase_ai_vdb_mariadb) |
| Runs | A DDEV service, Zilliz Cloud, or your own server | The site's own database, or a separate server | A file on the site's host |
| Provider | 1.1.0-beta4, no stable release | 1.0.1, a stable release |
| Varbase AI Search's `varbase_ai_search` is | A Milvus database | A MariaDB database | The file `varbase_ai_search.sqlite.sql` |

**SQLite by hand, without the recipe** (how the pilot was verified):

The SQLite provider needs the `sqlite-vec` loadable extension (`vec0.so`) in the directory PHP's
`sqlite3.extension_dir` names, for the CLI and FPM SAPIs separately, and a private files directory
with a `vdb` folder in it. On DDEV: the binary from the
[sqlite-vec releases](https://github.com/asg017/sqlite-vec/releases) in `.ddev/sqlite-vec/`, a
`.ddev/php/sqlite-vec.ini` with `sqlite3.extension_dir = /var/www/html/.ddev/sqlite-vec`, and
`mkdir -p private/vdb`. The provider's `2.0.x-dev` still carries PHP 8.4 implicitly nullable
deprecations (fixed on its 1.4.x branch after 1.4.0, drupal.org #3604047, not on 2.0.x). On a site that
displays errors they print before the endpoint's JSON, which the blocks tolerate but a plain `curl` does
not. A project that must stay on the released 1.4.0 needs two local patches instead: that PHP 8.4 fix,
and the vector query sqlite-vec 0.1.7+ refuses because 1.4.0 sends `k = ?` together with `LIMIT`.

### Provider bugs that matter for Ask AI

- **Milvus:** `dropCollection()` ignores the database argument and always drops from the default database.
  Clearing an index runs it, then creates the collection again, so in `varbase_ai_search` the vectors of removed
  content are likely to stay. Found by a test that left its throw-away collection behind. The clearing itself was
  not run.
- **SQLite:** the released 1.4.0 cannot search, and `2.0.x-dev` cannot create a new database file from a plain
  path (step 2c).
- **MariaDB:** 1.0.1 crashes when an index with no server is saved, which happens while Varbase Search Base sets up
  its keyword index. Apply Varbase Search Base before installing the provider (step 2b and
  [Known issues](#known-issues)).

Each recipe's provider was tested on its own, with the `ai_search` bundled in `drupal/ai`, while Varbase AI Search
and AI Answers bring the standalone `ai_search` 1.3 (see [Vector backend](#vector-backend)). Together with Ask AI:
CI applies it on MariaDB but neither indexes nor asks a question, and the checks under [Checked](#checked)
answered questions with the SQLite provider.

## Vector backend

Milvus, through `drupal/ai_vdb_provider_milvus`, is the first supported backend, in
[the decision record](https://www.drupal.org/project/varbase_ai_search_base/blob/1.0.x/docs/decisions/0001-vector-search-backend.md)
in Varbase AI Search. The recipe does not hard-wire it: the vector database is the site's default provider, so
another provider works without changing the recipe. Two things the decision record left unchecked are now known:

- The Milvus provider 1.1.0-beta4 requires `drupal/ai-ai_search` (the subtree split of the module
  bundled in `drupal/ai`), while Varbase AI Search and AI Answers require the standalone `drupal/ai_search` 1.3.
  Both install side by side and both are a module named `ai_search`. Which one Drupal loads is not
  guaranteed. With the standalone one alone (the SQLite path) Drupal picks it over the bundled copy.
- No patch is needed on AI Search: 1.3.0-alpha5 returns the per-result data AI Answers needs.

## Automated testing

GitLab CI on [git.drupalcode.org](https://git.drupalcode.org/project/varbase_ai_answers_base) (`.gitlab-ci.yml`) runs on every merge
request and every push to `1.0.x`, like the other Varbase AI recipes: `composer validate` and a lint of every YAML
file.

The functional tests in `tests/features` (Playwright and Cucumber through
[`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e)) run against a site of your own:
`yarn install`, then `LAUNCH_URL=https://your-site.ddev.site yarn test`.

## Checked

In CI on every change, as above. By hand on 5 October 2026, twice:

- On a Varbase 11 site deployed from the Upsun template (Drupal 11.4.5, `drupal/ai` 1.4.7, OpenAI
  `text-embedding-3-small`, Anthropic chat, SQLite provider 1.4.0 patched): 62 of 62 items indexed, and "How does
  Varbase handle security?" on a Canvas page answered with four cited sources, no console errors.
- On a fresh `drupal/varbase_project` 11.0 build (Drupal 11.4.8, Canvas 1.12.0, amazee.ai chat and embeddings with
  no key, SQLite provider `2.0.x-dev`), following this README's commands as they were then, on `1.0.x-dev`: 18 of
  18 items indexed, and "What is Varbase and what does it include?" on a Canvas page answered with a cited source,
  no console errors. The fresh build is what found the Canvas facts in
  [The Ask AI pattern and Canvas](#the-ask-ai-pattern-and-canvas).

**Not checked:** CI neither indexes nor asks a question, and no check above answered with the Milvus or MariaDB
provider.

## Known issues

- **`ai_vdb_provider_mariadb` 1.0.1** crashes with `Call to a member function getBackend() on null` when a Search API
  index that has no server yet is saved. Its `search_api_index_update` hook calls
  `$index->getServerInstance()->getBackend()` without checking for a server, and the Drupal CMS Search recipe,
  which Varbase Search Base applies, saves such an index while it sets up its keyword index. The recipe's rollback
  can then hide the error behind a `ReverseContainer::generateServiceIdHash()` TypeError. **Workaround:** apply
  Varbase Search Base before installing the provider. A Varbase site already has it applied, and CI does the same.
  An upstream fix is pending.
- Retrieval has no language filter (ai_search 3562047): a chunk in another language can be
  retrieved. The agent is told to answer in the visitor's language, and the reference cards render
  in the page language.
- Unpublished content is excluded by the `entity_status` processor. Beyond the obvious, an
  unpublished Canvas page renders only Twig debug comments for anonymous, the HTML-to-Markdown
  converter rejects comment-only HTML, and Search API aborts the whole indexing run on it.
- The Demo's gap (a follow-up about program length answered "no information" while a source showed
  the figure) is mitigated only by the agent's instructions, not fixed.
- A Canvas page cited as a source renders in full inside the Sources card: `reference_view_mode`
  is `teaser`, which Canvas pages do not have. Nodes render as teasers.
- Every indexed chunk and every question costs an embeddings call, plus one chat call per question.

## Related recipes

| Recipe | What it does |
|---|---|
| [Varbase AI Search](https://www.drupal.org/project/varbase_ai_search_base) | The vector index of the site's content, on the default vector database. |
| [Varbase AI Chatbot Base](https://www.drupal.org/project/varbase_ai_chatbot_base) | A visitor chatbot over that index. |
| [Varbase AI VDB: MariaDB](https://www.drupal.org/project/varbase_ai_vdb_mariadb) | MariaDB's native `VECTOR` type as the vector database. |
| [Varbase AI VDB: Milvus](https://www.drupal.org/project/varbase_ai_vdb_milvus) | Milvus or Zilliz Cloud as the vector database. |

## License

GPL-2.0-or-later. See [LICENSE](LICENSE). Maintained by [Vardot](https://www.vardot.com).
