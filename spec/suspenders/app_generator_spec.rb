require "spec_helper"

RSpec.describe Suspenders::AppGenerator do
  it "includes ExitOnFailure" do
    expect(described_class.ancestors).to include(Suspenders::ExitOnFailure)
  end

  it "skips spring by default" do
    expect(described_class.class_options[:skip_spring]&.default).to be true
  end
end
