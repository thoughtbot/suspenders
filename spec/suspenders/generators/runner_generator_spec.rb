require "spec_helper"

RSpec.describe Suspenders::RunnerGenerator, type: :generator do
  it "generates and destroys the configuration for the app to run" do
    with_fake_app do
      copy_file "bin_setup", "bin/setup"
      copy_file "README.md.erb", "README.md"

      invoke! Suspenders::RunnerGenerator

      expect("Procfile").to exist_as_a_file
      expect(".sample.env").to exist_as_a_file
      expect("bin/setup").to match_contents(/\.sample\.env/)
      expect("README.md").to match_contents(/\.sample\.env/)

      revoke! Suspenders::RunnerGenerator

      expect("README.md").not_to match_contents(/\.sample\.env/)
      expect("bin/setup").not_to match_contents(/\.sample\.env/)
      expect(".sample.env").not_to exist_as_a_file
      expect("Procfile").not_to exist_as_a_file
    end
  end
end
