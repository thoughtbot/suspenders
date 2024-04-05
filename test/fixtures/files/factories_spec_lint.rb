require "rails_helper"

RSpec.describe "Factories" do
  it "has valid factoties" do
    FactoryBot.lint traits: true
  end
end
