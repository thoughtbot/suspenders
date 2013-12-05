@disable-bundler
Feature: Rake works in the suspended project
  Background:
    Given I ensure no databases exist for "test_project"

  Scenario: Running rake in the suspended project
    When I suspend a project called "test_project"
    And I cd to the "test_project" root
    And I obtain a fresh checkout
    And I setup the project
    Then I can cleanly rake the project

  Scenario: Making a spec then running rake
    When I suspend a project called "test_project"
    And I cd to the "test_project" root
    And I obtain a fresh checkout
    And I setup the project
    And I generate "model post title:string"
    And I run migrations
    Then I can cleanly rake the project
