@varbase-ai-answers-base @ai @recipes @local @development
Feature: Varbase AI Recipe - AI Answers Base - Ask AI answers from the site's own content
  As a site visitor
  I want to ask the site a question and get an answer with the pages it comes from
  So that I can trust the answer and read more on the site

  @flaky
  Scenario: Verify a visitor asks the site a question and gets an answer with its sources
    Given I am an anonymous user
      And I am on the homepage
     When I ask the site "What is Varbase?"
     Then the answer should mention "Varbase"
      And the answer should cite the "About Varbase" page
