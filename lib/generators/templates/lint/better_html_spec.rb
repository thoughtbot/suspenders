require "spec_helper"

describe "ERB Implementation" do
  def self.erb_lint
    configuration = ActiveSupport::ConfigurationFile.parse(".erb-lint.yml")

    ActiveSupport::OrderedOptions.new.merge!(configuration.deep_symbolize_keys!)
  end

  Rails.root.glob(erb_lint.glob).each do |template|
    it "raises no html errors in #{template.relative_path_from(Rails.root)}" do
      validator = BetterHtml::BetterErb::ErubiImplementation.new(template.read)

      validator.validate!
    end
  end
end
