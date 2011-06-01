Feature: Rake works in the suspended project

  Scenario: Running rake in the suspended project
    When I drop and create the required databases
    And I run the rake task "db:create"
    And I run the rake task "db:migrate"
    And I run the rake task "db:test:prepare"
    And I run the rake task "cucumber"
    Then I see a successful response in the shell

  Scenario: Making a spec then running rake
    When I drop and create the required databases
    And I generate "model post title:string"
    And I run the rake task "db:migrate"
    And I run the rake task "db:test:prepare"
    And I run the rake task "spec"
    Then I see a successful response in the shell
