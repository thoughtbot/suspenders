require "spec_helper"

RSpec.describe Suspenders::Actions::Test::RaiseI18nError do
  describe "#apply" do
    it "enables the raising of errors for missing translations" do
      setup_action described_class do |action, target_file|
        write_file target_file, <<~RUBY
          # Raises error for missing translations.
          # config.i18n.raise_on_missing_translations = true
        RUBY

        action.apply

        expect(target_file).not_to have_commented <<~TEXT
          config.i18n.raise_on_missing_translations = true
        TEXT
      end
    end
  end
end
