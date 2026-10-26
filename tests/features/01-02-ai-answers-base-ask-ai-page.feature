@varbase-ai-answers-base @ai @recipes @canvas @local @development
Feature: Varbase AI Recipe - AI Answers Base - An Ask AI page for visitors
  As a site builder
  I want to drop the Ask AI pattern onto a Canvas page and publish it
  So that visitors get a question box with answers and sources

  Scenario: Check the Ask AI pattern is in the Canvas Library
    Given I am a logged in user with the "Webmaster" user
     When I open the "Features" Canvas page in the editor
      And I open the "Patterns" tab in the Canvas Library
     Then the Canvas Library "Patterns" tab should list "Ask AI (cited answers)"
