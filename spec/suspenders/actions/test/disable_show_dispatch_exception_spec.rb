require "spec_helper"

RSpec.describe Suspenders::Actions::Test::DisableShowDispatchException do
  describe "#apply" do
    it "disables the action dispatch show exceptions configuration" do
      setup_action described_class do |action, target_file|
        write_file target_file, <<~RUBY
          # Render exception templates for rescuable exceptions and raise for…
          config.action_dispatch.show_exceptions = :rescuable
        RUBY

        action.apply

        expect(target_file).to have_commented <<~TEXT
          config.action_dispatch.show_exceptions = :rescuable
        TEXT
      end
    end
  end
end
