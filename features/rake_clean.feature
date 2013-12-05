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

  Scenario: Making a model spec then running rake
    When I suspend a project called "test_project"
    And I cd to the "test_project" root
    And I obtain a fresh checkout
    And I setup the project
    And I generate "model post title:string"
    And I run migrations
    Then I can cleanly rake the project

  Scenario: Making a feature spec then running rake
    When I suspend a project called "test_project"
    And I cd to the "test_project" root
    And I obtain a fresh checkout
    And I setup the project
    And I write to "spec/features/example_spec.rb" with:
      """
      require 'spec_helper'

      feature 'Example feature spec' do
        scenario 'using a method from the Features module' do
          expect(example_method).to eq('Expected Value')
        end
      end
      """
    And I write to "spec/support/features/example.rb" with:
      """
      module Features
        def example_method
          'Expected Value'
        end
      end
      """
