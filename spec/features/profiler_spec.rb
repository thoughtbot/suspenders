require "spec_helper"

RSpec.describe "suspenders:profiler", type: :generator do
  it "sets up rack-min-profiler" do
    with_app { generate("suspenders:profiler") }

    expect("config/initializers/rack_mini_profiler.rb").to \
      match_contents(/Rack::MiniProfilerRails.initialize/)
    expect("Gemfile").to match_contents(/rack-mini-profiler/)
    expect(".sample.env").to match_contents(/RACK_MINI_PROFILER=0/)
  end

  it "removes rack-min-profiler" do
    with_app { destroy("suspenders:profiler") }

    expect("config/initializers/rack_mini_profiler.rb").not_to exist_as_a_file
    expect("Gemfile").not_to match_contents(/rack-mini-profiler/)
    expect(".sample.env").not_to exist_as_a_file
  end
end
