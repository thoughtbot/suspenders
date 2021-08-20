require "spec_helper"

RSpec.describe Suspenders::RunnerGenerator, type: :generator do
  # TODO: (Bonus) Better test coverage, specially for bin/setup
  it "generates and destroys the configuration for the app to run" do
    with_app_dir do
      copy_file_ "bin_setup", "bin/setup"
      copy_file_ "README.md.erb", "README.md"

      generator = new_invoke_generator(Suspenders::RunnerGenerator)
      generator.invoke_all

      expect("Procfile").to exist_as_a_file
      expect(".sample.env").to exist_as_a_file
      expect("bin/setup").to match_contents(/\.sample\.env/)
      expect("README.md").to match_contents(/\.sample\.env/)

      generator = new_revoke_generator(Suspenders::RunnerGenerator)
      generator.invoke_all

      expect("README.md").not_to match_contents(/\.sample\.env/)
      expect("bin/setup").not_to match_contents(/\.sample\.env/)
      expect(".sample.env").not_to exist_as_a_file
      expect("Procfile").not_to exist_as_a_file
    end
  end
end
