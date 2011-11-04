@disable-bundler
Feature: Skipping clearance
  As a developer
  I want to suspend an app without clearance
  So that I can build apps without users, or with other authentication libraries

  Scenario: Passing --clearance=false
    When I suspend a project called "test_project" with:
      | argument    | value |
      | --clearance | false  |
    And I cd to the "test_project" root
    Then "clearance" should not be installed
    And I can cleanly rake the project
