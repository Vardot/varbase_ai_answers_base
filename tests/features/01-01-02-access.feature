@varbase-ai @access
Feature: Only site administrators reach what the Varbase AI Answers Base recipe adds
  As a site owner
  I want the Ask AI settings kept from visitors who are not administrators
  So that the AI configuration is not exposed

  Scenario: An anonymous visitor cannot open the Ask AI settings
    Given I am an anonymous user
    When I navigate to "/admin/config/ai/ai-answers/agents"
    Then I should not see "Varbase Ask AI"
     And I the page should not have PHP errors
