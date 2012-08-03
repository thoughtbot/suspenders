@disable-bundler
Feature: Creating a Heroku app

  Scenario: --heroku=true
    When I suspend a project called "test_project" with:
      | argument | value |
      | --heroku | true  |
    Then the "test_project-staging" heroku app should exist
    And the "test_project-production" heroku app should exist
