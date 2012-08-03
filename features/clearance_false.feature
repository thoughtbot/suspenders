@disable-bundler
Feature: Skipping Clearance

  Scenario: --clearance=false
    When I suspend a project called "test_project" with:
      | argument    | value |
      | --clearance | false |
    And I cd to the "test_project" root
    Then "clearance" should not be installed
    And I can cleanly rake the project
