require "spec_helper"

RSpec.describe "suspenders:lint", type: :generator do
  it "sets up standard" do
    with_app { generate("suspenders:lint") }

    expect("Gemfile").to match_contents(/standard/)

    run_in_project do
      expect(`rake -T`).to include("rake standard")
    end
  end

  it "removes standard" do
    with_app do
      generate("suspenders:lint")
      destroy("suspenders:lint")
    end

    expect("Gemfile").not_to match_contents(/standard/)

    run_in_project do
      expect(`rake -T`).not_to include("rake standard")
    end
  end
end
