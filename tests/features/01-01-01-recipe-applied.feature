@varbase-ai @answers @recipe
Feature: The Varbase AI Answers Base recipe sets up Ask AI
  As a Varbase site builder
  I want the recipe to add the Ask AI agent and wire AI Answers to it
  So that a site can answer visitors' questions with cited answers from its own content

  Background:
    Given I am a logged in user with the "Webmaster" user

  Scenario: The Ask AI agent exists
    When I navigate to "/admin/config/ai/tools-automation/agents"
    Then I should see "Varbase Ask AI"
     And I the page should not have PHP errors

  Scenario: AI Answers uses the Ask AI agent
    When I navigate to "/admin/config/ai/ai-answers/agents"
    Then I should see "Varbase Ask AI"
     And I the page should not have PHP errors

  Scenario: The vector index from Varbase AI Search Base is there
    When I navigate to "/admin/config/search/search-api"
    Then I should see "Content vector (Ask AI)"
     And I the page should not have PHP errors
