@disable-bundler
Feature: Creating a Github repo

  Scenario: --github=organization/project
    When I suspend a project called "test_project" with:
      | argument | value                |
      | --github | organization/project |
    Then the "organization/project" Github repo should exist
