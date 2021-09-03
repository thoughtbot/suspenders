require "spec_helper"

RSpec.describe Suspenders::Production::DeploymentGenerator, type: :generator do
  def invoke_deployment_generator!
    copy_file "README.md.erb", "README.md"
    invoke! Suspenders::Production::DeploymentGenerator
  end

  def revoke_deployment_generator!
    invoke_deployment_generator!
    revoke! Suspenders::Production::DeploymentGenerator
  end

  describe "invoke" do
    it "generates a bin/deploy binary" do
      with_fake_app do
        invoke_deployment_generator!

        expect("bin/deploy").to exist_as_a_file.and be_executable
      end
    end

    it "generates a README entry" do
      with_fake_app do
        invoke_deployment_generator!

        expect("README.md").to match_contents(%r{bin/deploy})
      end
    end
  end

  describe "revoke" do
    it "destroys the bin/deploy binary" do
      with_fake_app do
        revoke_deployment_generator!

        expect("bin/deploy").not_to exist_as_a_file
      end
    end

    it "destroys the README entry" do
      with_fake_app do
        revoke_deployment_generator!

        expect("README.md").not_to match_contents(%r{bin/deploy})
      end
    end
  end
end
