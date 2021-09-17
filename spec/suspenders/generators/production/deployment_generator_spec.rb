require "spec_helper"

RSpec.describe Suspenders::Production::DeploymentGenerator, type: :generator do
  before_invoke = proc do
    copy_file "README.md.erb", "README.md"
  end

  describe "invoke" do
    it "generates a bin/deploy binary" do
      with_fake_app do
        invoke! Suspenders::Production::DeploymentGenerator, &before_invoke

        expect("bin/deploy").to exist_as_a_file.and be_executable
      end
    end

    it "generates a README entry" do
      with_fake_app do
        invoke! Suspenders::Production::DeploymentGenerator, &before_invoke

        expect("README.md").to match_contents(%r{bin/deploy})
      end
    end
  end

  describe "revoke" do
    it "destroys the bin/deploy binary" do
      with_fake_app do
        invoke_then_revoke!(
          Suspenders::Production::DeploymentGenerator,
          &before_invoke
        )

        expect("bin/deploy").not_to exist_as_a_file
      end
    end

    it "destroys the README entry" do
      with_fake_app do
        invoke_then_revoke!(
          Suspenders::Production::DeploymentGenerator,
          &before_invoke
        )

        expect("README.md").not_to match_contents(%r{bin/deploy})
      end
    end
  end
end
