require "spec_helper"

RSpec.describe "suspenders:runner", type: :generator do
  it "configures the app for running" do
    with_app { generate("suspenders:runner") }

    expect("Procfile").to exist_as_a_file
    expect(".sample.env").to exist_as_a_file
    expect("bin/setup").to match_contents(/\.sample\.env/)
    expect("README.md").to match_contents(/\.sample\.env/)
  end

  it "removes custom app running configuration" do
    with_app { destroy("suspenders:runner") }

    expect("README.md").not_to match_contents(/\.sample\.env/)
    expect("bin/setup").not_to match_contents(/\.sample\.env/)
    expect(".sample.env").not_to exist_as_a_file
    expect("Procfile").not_to exist_as_a_file
  end

  it "configures the app with a shell script bin/setup" do
    with_app do
      copy_file "bin_setup", "bin/setup"
      generate("suspenders:runner")
    end

    expect("bin/setup").to match_contents(/\.sample\.env/)
  end
end
