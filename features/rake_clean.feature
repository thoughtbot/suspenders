Feature: Rake works in the suspended project

  Scenario: Running rake in the suspended project
    When I run the rake task "db:create:all"
    And I run the rake task "db:migrate"
    And I run the rake task "cucumber"
    Then I see a successful response in the shell
