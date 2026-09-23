require "rails_helper"

RSpec.describe "Factories" do
  it "has valid factories" do
    expect { FactoryBot.lint traits: true }.not_to raise_error
  end
end
