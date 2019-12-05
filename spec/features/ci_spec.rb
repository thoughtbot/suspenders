require "spec_helper"

RSpec.describe "suspenders:ci", type: :generator do
  it "configures Circle with SimpleCov" do
    with_app { generate("suspenders:ci") }

    expect("Gemfile").to match_contents(/simplecov/)
    expect("test/test_helper.rb").to match_contents(/SimpleCov.coverage_dir/)
    expect("test/test_helper.rb").to match_contents(/SimpleCov.start/)
    expect("circle.yml").to exist_as_a_file
  end

  it "removes Circle and SimpleCov" do
    with_app { destroy("suspenders:ci") }

    expect("circle.yml").not_to exist_as_a_file
    expect("test/test_helper.rb").not_to match_contents(/SimpleCov/)
    expect("Gemfile").not_to match_contents(/simplecov/)
  end

  it "configures RSpec" do
    with_app do
      copy_file "spec_helper.rb", "spec/spec_helper.rb"

      generate("suspenders:ci")
    end

    expect("spec/spec_helper.rb").to match_contents(/SimpleCov.coverage_dir/)
    expect("spec/spec_helper.rb").to match_contents(/SimpleCov.start/)
  end
end
