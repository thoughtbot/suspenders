require "spec_helper"

RSpec.describe Suspenders::Generators::Base do
  it "includes ExitOnFailure" do
    expect(described_class.ancestors).to include(Suspenders::ExitOnFailure)
  end
end
