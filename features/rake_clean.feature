@disable-bundler
Feature: Rake works in the suspended project

  Scenario: Running rake in the suspended project
    When I suspend a project called "test_project"
    And I cd to the "test_project" root
    And I drop and create the required databases
    Then I can cleanly rake the project

  Scenario: Making a spec then running rake
    When I suspend a project called "test_project"
    And I generate "model post title:string"
    And I drop and create the required databases
    And I run the rake task "db:migrate"
    And I run the rake task "db:test:prepare"
    And I run the rake task "spec"
    Then I see a successful response in the shell
