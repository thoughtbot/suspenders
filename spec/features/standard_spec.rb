require "spec_helper"

RSpec.describe "suspenders:standard", type: :generator do
  it "sets up standard" do
    with_app { generate("suspenders:standard") }

    # TODO: would be good to test this is only in the dev/test group
    expect("Gemfile").to match_contents(/standard/)

    run_in_project do
      expect(`rake -T`).to include("rake standard")
    end

    # TODO: better way to test this? (don't even know if this works)
    # TODO: would it be better to disable linters by default, so there'd be no
    # action to take here?
    expect(".hound.yml").
      to match_contents(/ruby:\n(\w.+)?  enabled: false/)
  end

  it "removes standard" do
    with_app { destroy("suspenders:standard") }

    expect("Gemfile").not_to match_contents(/standard/)

    run_in_project do
      expect(`rake -T`).not_to include("rake standard")
    end

    expect(".hound.yml").
      to match_contents(/ruby:\n(\w.+)?  enabled: true/)
  end
end
