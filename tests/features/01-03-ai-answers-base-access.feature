@varbase-ai-answers-base @ai @recipes @access @local @development @staging @production
Feature: Varbase AI Recipe - AI Answers Base - Visitors may ask, only administrators configure
  As a site owner
  I want everyone to be able to ask questions but only the super administrator to configure AI Answers
  So that the public question box works while its settings stay protected

  Scenario Outline: Check the "<user>" user cannot configure AI Answers
    Given I am a logged in user with the "<user>" user
     When I go to "/admin/config/ai/ai-answers/agents"
     Then the response status code should be 403
      And I should see "Access denied"

    Examples:
      | user           |
      | Content editor |
      | Content admin  |
      | Site admin     |

  Scenario: Check an anonymous visitor cannot configure AI Answers
    Given I am an anonymous user
     When I go to "/admin/config/ai/ai-answers/agents"
     Then the response status code should be 403
      And I should not see "Varbase Ask AI"
