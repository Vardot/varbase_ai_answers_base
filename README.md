[![Varbase](https://raw.githubusercontent.com/Vardot/varbase/11.0.x/images/varbase-logo.png)](https://www.drupal.org/project/varbase)

# Varbase AI Answers Base (Ask AI)
[![Varbase AI Answers Base (Ask AI)](https://img.shields.io/badge/Varbase%20AI%20Answers%20Base%20%28Ask%20AI%29-1.0.0--alpha1-0d6efc?labelColor=001d38&style=flat-square)](https://www.drupal.org/project/varbase_ai_answers_base)

An **opt-in** Drupal recipe that adds "Ask AI" to a Varbase 11 site: a public question box that answers
in plain language with numbered citations and source cards, grounded only in the site's own content.
The Drupal AI Demo calls the same feature Ask AI. This is the Varbase version of it.

## Documentation

Read the [Varbase AI Answers Base (Ask AI) documentation](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-answers-base) on the Varbase docs site.

## Install and apply

Start from a Varbase 11 build with Varbase AI Base applied, then run these commands from the project folder. They
are the whole procedure.

```bash
# 1. Fetch the recipes.
#    The ignore line also covers the vector database recipe of step 2.
ddev composer config --json extra.drupal-recipe-unpack.ignore '["drupal/varbase_ai_search_base", "drupal/varbase_ai_answers_base", "drupal/varbase_ai_vdb_milvus", "drupal/varbase_ai_vdb_mariadb"]'
ddev composer require drupal/varbase_ai_answers_base:~1
#    Enable AI Answers now, outside the recipe, and rebuild caches: Canvas generates the AI Answers
#    block components the Ask AI pattern needs only outside a recipe apply.
ddev drush en ai_answers -y
ddev drush cr
```

**Step 2: a vector database. Run the commands of ONE of these three recipes.** Each one installs its provider,
connects it and makes it the site default, which Varbase AI Search reads. Varbase AI Search names its vector
database `varbase_ai_search`, so each block ends with the one thing that name needs. The remote setups (Zilliz
Cloud, a separate server, Upsun) are on each recipe's docs page, linked in each heading.

**2a. Milvus**, local in DDEV. [Docs](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-vdb-milvus)

```bash
ddev composer require drupal/varbase_ai_vdb_milvus:~1
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
template runs 10.11 until its database service is upgraded (read its docs page first: a downgrade deletes the
data). [Docs](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-vdb-mariadb)

Apply Varbase Search Base **before** the MariaDB provider is installed. A Varbase site already has it applied. On
any other site, apply it first, because the provider crashes on the keyword index it sets up (see
[Known issues](https://docs.varbase.vardot.com/developers/understanding-varbase/varbase-ai-recipes/varbase-ai-answers-base)):

```bash
ddev drush cr
ddev drush recipe ../recipes/varbase_search_base
ddev drush cr
```

Then:

```bash
ddev composer require drupal/varbase_ai_vdb_mariadb:~1
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
a recipe of its own, and this one leaves it out: a site on another theme is not stopped
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

## Automated testing

GitLab CI on [git.drupalcode.org](https://git.drupalcode.org/project/varbase_ai_answers_base) (`.gitlab-ci.yml`) runs on every merge
request and every push to `1.0.x`, like the other Varbase AI recipes: `composer validate` and a lint of every YAML
file.

The functional tests in `tests/features` (Playwright and Cucumber through
[`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e)) run against a site of your own:
`yarn install`, then `LAUNCH_URL=https://your-site.ddev.site yarn test`.

## License

GPL-2.0-or-later. See [LICENSE](LICENSE). Maintained by [Vardot](https://www.vardot.com).
