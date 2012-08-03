@disable-bundler
Feature: Creating a Heroku app

  Scenario: --heroku=true
    When I suspend a project called "test_project" with:
      | argument | value |
      | --heroku | true  |
    Then the "test_project-staging" Heroku app should exist
    And the "test_project-production" Heroku app should exist
