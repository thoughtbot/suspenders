require "spec_helper"

RSpec.describe "suspenders:inline_svg", type: :generator do
  it "generates the configuration for inline_svg" do
    with_app { generate("suspenders:inline_svg") }

    expect("config/initializers/inline_svg.rb").to match_contents(/InlineSvg/)
    expect("Gemfile").to match_contents(/inline_svg/)
  end
end
