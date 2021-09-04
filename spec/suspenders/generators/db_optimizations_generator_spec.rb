require "spec_helper"

RSpec.describe Suspenders::DbOptimizationsGenerator, type: :generator do
  describe "invoke" do
    it "bundles the bullet gem" do
      with_fake_app do
        invoke! Suspenders::DbOptimizationsGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and have_bundled("install")
          .matching(/bullet/)
      end
    end

    it "configures development.rb with bullet" do
      with_fake_app do
        invoke! Suspenders::DbOptimizationsGenerator

        expect("config/environments/development.rb")
          .to have_no_syntax_error
          .and match_contents(/Bullet.enable/)
      end
    end
  end

  describe "revoke" do
    it "removes the bullet gem from Gemfile" do
      with_fake_app do
        invoke_then_revoke! Suspenders::DbOptimizationsGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end

    it "removes bullet configuration from development.rb" do
      with_fake_app do
        invoke_then_revoke! Suspenders::DbOptimizationsGenerator

        expect("config/environments/development.rb")
          .to have_no_syntax_error
          .and match_original_file
      end
    end
  end
end
