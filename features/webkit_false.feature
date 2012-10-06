@disable-bundler
Feature: Skipping Capybara Webkit

  Scenario: --webkit=false
    When I suspend a project called "test_project" with:
      | argument | value |
      | --webkit | false |
    And I cd to the "test_project" root
    Then "capybara-webkit" should not be installed
    And "webkit" should not be included in "spec/spec_helper.rb"
    And I can cleanly rake the project
