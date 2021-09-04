require "spec_helper"

RSpec.describe Suspenders::RunnerGenerator, type: :generator do
  before_generate = proc do
    copy_file "bin_setup", "bin/setup"
    copy_file "README.md.erb", "README.md"
  end

  describe "invoke" do
    it "creates a Procfile" do
      with_fake_app do
        invoke! Suspenders::RunnerGenerator, &before_generate

        expect("Procfile").to exist_as_a_file
      end
    end

    it "creates a .sample.env file" do
      with_fake_app do
        invoke! Suspenders::RunnerGenerator, &before_generate

        expect(".sample.env").to exist_as_a_file
      end
    end

    it "adds .sample.env handling to bin/setup" do
      with_fake_app do
        invoke! Suspenders::RunnerGenerator, &before_generate

        expect("bin/setup").to match_contents(/\.sample\.env/)
      end
    end

    it "adds .sample.env information to the README" do
      with_fake_app do
        invoke! Suspenders::RunnerGenerator, &before_generate

        expect("README.md").to match_contents(/\.sample\.env/)
      end
    end
  end

  describe "revoke" do
    it "destroys Procfile" do
      with_fake_app do
        invoke_then_revoke! Suspenders::RunnerGenerator, &before_generate

        expect("Procfile").not_to exist_as_a_file
      end
    end

    it "destroys .sample.env" do
      with_fake_app do
        invoke_then_revoke! Suspenders::RunnerGenerator, &before_generate

        expect(".sample.env").not_to exist_as_a_file
      end
    end

    it "removes .sample.env handling from bin/setup" do
      with_fake_app do
        invoke_then_revoke! Suspenders::RunnerGenerator, &before_generate

        expect("bin/setup").not_to match_contents(/\.sample\.env/)
      end
    end

    it "removes .sample.env information from the README" do
      with_fake_app do
        invoke_then_revoke! Suspenders::RunnerGenerator, &before_generate

        expect("README.md").not_to match_contents(/\.sample\.env/)
      end
    end
  end
end
