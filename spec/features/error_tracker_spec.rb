require "spec_helper"

RSpec.describe "suspenders:error_tracker", type: :generator do
  it "generates the Gemfile for error tracking" do
    with_app { generate("suspenders:error_tracker") }

    expect("Gemfile").to match_contents(%r{gem .honeybadger.})
  end

  it "cleans up the Gemfile from error tracking" do
    with_app { destroy("suspenders:error_tracker") }

    expect("Gemfile").not_to match_contents(%r{gem .honeybadger.})
  end
end

