@varbase-ai-answers-base @ai @recipes @a11y @local @development @staging @production
Feature: Varbase AI Recipe - AI Answers Base - Accessible Ask AI settings
  As a site administrator who uses assistive technology
  I want the Ask AI settings pages to work with a keyboard and a screen reader
  So that I can manage Ask AI like anyone else

  Scenario Outline: Check the AI Answers agents page keeps the "<rule>" accessibility rule
    Given I am a logged in user with the "Webmaster" user
     When I go to "/admin/config/ai/ai-answers/agents"
     Then the page should not violate the accessibility rule "<rule>"

    Examples:
      | rule              |
      | label             |
      | link-name         |
      | duplicate-id-aria |
      | aria-valid-attr   |
