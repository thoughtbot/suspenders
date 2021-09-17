require "spec_helper"

RSpec.describe Suspenders::Production::DeploymentGenerator, type: :generator do
  def copy_files_to_fake_app
    copy_file "README.md.erb", "README.md"
  end

  describe "invoke" do
    it "generates a bin/deploy binary" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Suspenders::Production::DeploymentGenerator

        expect("bin/deploy").to exist_as_a_file.and be_executable
      end
    end

    it "generates a README entry" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Suspenders::Production::DeploymentGenerator

        expect("README.md").to match_contents(%r{bin/deploy})
      end
    end
  end

  describe "revoke" do
    it "destroys the bin/deploy binary" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Suspenders::Production::DeploymentGenerator

        expect("bin/deploy").not_to exist_as_a_file
      end
    end

    it "destroys the README entry" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Suspenders::Production::DeploymentGenerator

        expect("README.md").not_to match_contents(%r{bin/deploy})
      end
    end
  end
end
