require "spec_helper"

RSpec.describe Suspenders::RunnerGenerator, type: :generator do
  def copy_files_to_fake_app
    copy_file "bin_setup", "bin/setup"
    copy_file "README.md.erb", "README.md"
  end

  describe "invoke" do
    it "creates a Procfile" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Suspenders::RunnerGenerator

        expect("Procfile").to exist_as_a_file
      end
    end

    it "creates a .sample.env file" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Suspenders::RunnerGenerator

        expect(".sample.env").to exist_as_a_file
      end
    end

    it "adds .sample.env handling to bin/setup" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Suspenders::RunnerGenerator

        expect("bin/setup").to match_contents(/\.sample\.env/)
      end
    end

    it "adds .sample.env information to the README" do
      with_fake_app do
        copy_files_to_fake_app

        invoke! Suspenders::RunnerGenerator

        expect("README.md").to match_contents(/\.sample\.env/)
      end
    end
  end

  describe "revoke" do
    it "destroys Procfile" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Suspenders::RunnerGenerator

        expect("Procfile").not_to exist_as_a_file
      end
    end

    it "destroys .sample.env" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Suspenders::RunnerGenerator

        expect(".sample.env").not_to exist_as_a_file
      end
    end

    it "removes .sample.env handling from bin/setup" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Suspenders::RunnerGenerator

        expect("bin/setup").not_to match_contents(/\.sample\.env/)
      end
    end

    it "removes .sample.env information from the README" do
      with_fake_app do
        copy_files_to_fake_app

        invoke_then_revoke! Suspenders::RunnerGenerator

        expect("README.md").not_to match_contents(/\.sample\.env/)
      end
    end
  end
end
