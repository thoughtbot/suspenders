require "spec_helper"

RSpec.describe "bulldozer:json", type: :generator do
  it "generates the Gemfile for JSON parsing" do
    with_app { generate("bulldozer:json") }

    expect("Gemfile").to match_contents(%r{gem .oj.})
  end

  it "cleans up the Gemfile from JSON parsing" do
    with_app { destroy("bulldozer:json") }

    expect("Gemfile").not_to match_contents(%r{gem .oj.})
  end
end
