require "spec_helper"

RSpec.describe "suspenders:static", type: :generator do
  it "adds the gem and pages directory" do
    with_app { generate("suspenders:static") }

    expect("Gemfile").to match_contents(/high_voltage/)
    expect("app/views/pages/.keep").to exist_as_a_file
  end

  it "removes the gem and pages directory" do
    with_app { destroy("suspenders:static") }

    expect("app/views/pages/.keep").not_to exist_as_a_file
    expect("Gemfile").not_to match_contents(/high_voltage/)
  end
end
