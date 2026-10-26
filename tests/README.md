# Varbase functional testing suite

Playwright and Cucumber through [`@vardot/varbase-e2e`](https://www.npmjs.com/package/@vardot/varbase-e2e), on a
Varbase 11 site with this recipe applied.

| Feature | Covers |
| --- | --- |
| `01-01-ai-answers-base-ask.feature` | A visitor asks the site a question and gets an answer that cites the site's pages |
| `01-02-ai-answers-base-ask-ai-page.feature` | A site builder finds the Ask AI pattern in the Canvas Library |
| `01-03-ai-answers-base-access.feature` | Editorial roles and visitors cannot configure AI Answers |
| `01-04-ai-answers-base-accessibility.feature` | The AI Answers agents page keeps the label, link name and ARIA rules |


## Run it

```bash
npm install
LAUNCH_URL=https://your-site.ddev.site npm test
```

The site needs the webmaster (`webmaster`) and one user per role, named after the role (`content_editor`,
`content_admin`, `seo_admin`, `site_admin`), all with the password in `LOGIN_PASS` (default `dD.123123ddd`).
`.gitlab-ci.yml` shows the whole setup.

## AI provider

CI applies the recipes this one builds on, in order: Drupal CMS AI, which sets up an amazee.ai trial as the
default provider, Varbase AI VDB: MariaDB and AI Answers, then this recipe and its Ask AI pattern. No key is
needed and answers come from a real model, in 7 to 9 seconds on a local site.

The question is asked the way the Ask AI question box does, by the steps in `tests/step-
definitions/answers.steps.js`. About one answer in three comes back as "I was unable to fully answer your
question within the allowed number of processing steps" (the agent allows 3 loops), so that scenario is tagged
`@flaky` and retried twice. That is a finding for the recipe, not a test problem.
