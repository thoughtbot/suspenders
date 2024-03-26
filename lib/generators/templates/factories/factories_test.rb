require "test_helper"

class FactoryBotsTest < ActiveSupport::TestCase
  class FactoryLintingTest < FactoryBotsTest
    test "linting of factories" do
      FactoryBot.lint traits: true
    end
  end
end
