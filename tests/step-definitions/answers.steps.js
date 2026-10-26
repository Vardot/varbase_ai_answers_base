// Steps that ask AI Answers a question the way the Ask AI question box does:
// the site's CSRF token first, then the question to the AI Answers endpoint.
const assert = require('assert');
const { When, Then } = require('@cucumber/cucumber');

// The AI agent this recipe sets up for Ask AI.
const AGENT = 'varbase_ai_answers';

/**
 * Ask the site a question through Ask AI, as the current visitor, from the current page.
 *
 * Example #1: When I ask the site "What is Varbase?"
 * Example #2: And I ask the site "How do I add a blog post?"
 * Example #3: When we ask the site "Which modules keep the site secure?"
 * Example #4: When I ask the site "Who builds Varbase?"
 * Example #5: And I ask the site "Is Varbase ready for Arabic?"
 */
When(/^(?:I |we )*ask the site "([^"]*)"$/, async function (question) {
  this.askAiReply = await this.page.evaluate(async ({ question, agent }) => {
    const token = await (await fetch('/session/token')).text();
    const reply = await fetch('/ai-answers/question', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json', Accept: 'application/json', 'X-CSRF-Token': token },
      body: JSON.stringify({ agent, question }),
    });
    return { status: reply.status, text: await reply.text() };
  }, { question, agent: AGENT });
});

function answer(world) {
  const reply = world.askAiReply;
  assert.ok(reply, 'The site was not asked anything in this scenario.');
  assert.strictEqual(reply.status, 200, `Ask AI answered with HTTP ${reply.status}: ${reply.text.slice(0, 200)}`);
  return JSON.parse(reply.text);
}

/**
 * Assert the Ask AI answer mentions a word.
 *
 * Example #1: Then the answer should mention "Varbase"
 * Example #2: And the answer should mention "Drupal"
 * Example #3: Then the answer should mention "security"
 * Example #4: Then the answer should mention "blog"
 * Example #5: And the answer should mention "Vardot"
 */
Then(/^the answer should mention "([^"]*)"$/, function (word) {
  const text = (answer(this).answer || {}).text || '';
  assert.ok(text.includes(word), `The answer does not mention "${word}": ${text.slice(0, 300)}`);
});

/**
 * Assert the Ask AI answer lists a page of the site among its sources.
 *
 * Example #1: Then the answer should cite the "About Varbase" page
 * Example #2: And the answer should cite the "Features" page
 * Example #3: Then the answer should cite the "Home" page
 * Example #4: Then the answer should cite the "Contact" page
 * Example #5: And the answer should cite the "Blog" page
 */
Then(/^the answer should cite the "([^"]*)" page$/, function (label) {
  const refs = ((answer(this).answer || {}).references || []).map((r) => r.label);
  assert.ok(refs.includes(label), `The answer does not cite "${label}". It cites: ${refs.join(', ') || 'nothing'}`);
});
