require "spec_helper"

RSpec.describe Suspenders::CiGenerator, type: :generator do
  describe "invoke" do
    it "bundles the simplecov gem" do
      with_fake_app do
        invoke! Suspenders::CiGenerator

        expect("Gemfile").to have_bundled("install").matching(/simplecov/)
      end
    end

    it "creates a circle.yml file" do
      with_fake_app do
        invoke! Suspenders::CiGenerator

        expect("circle.yml").to exist_as_a_file
      end
    end

    context "when it is an rspec project" do
      it "configures spec_helper.rb with SimpleCov" do
        with_fake_app do
          invoke! Suspenders::CiGenerator

          expect("spec/spec_helper.rb")
            .to match_contents(/SimpleCov.coverage_dir/)
            .and match_contents(/SimpleCov.start/)
            .and have_no_syntax_error
        end
      end
    end

    context "when it is a minitest project" do
      it "configures test_helper.rb instead of spec_helper.rb" do
        with_fake_app do
          rm_file "spec/spec_helper.rb"
          touch_file "test/test_helper.rb"

          invoke! Suspenders::CiGenerator

          expect("test/test_helper.rb")
            .to match_contents(/SimpleCov.coverage_dir/)
            .and match_contents(/SimpleCov.start/)
            .and have_no_syntax_error
        end
      end
    end
  end

  describe "revoke" do
    it "removes the simplecov gem from Gemfile" do
      with_fake_app do
        invoke_then_revoke! Suspenders::CiGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end

    it "destroys the circle.yml file" do
      with_fake_app do
        invoke_then_revoke! Suspenders::CiGenerator

        expect("circle.yml").not_to exist_as_a_file
      end
    end

    context "when it is an rspec project" do
      it "removes SimpleCov configuration from spec_helper.rb" do
        with_fake_app do
          invoke_then_revoke! Suspenders::CiGenerator

          expect("spec/spec_helper.rb")
            .to not_match_contents(/SimpleCov/)
            .and have_no_syntax_error
        end
      end
    end

    context "when it is a minitest project" do
      it "removes SimpleCov configuration from test_helper.rb" do
        with_fake_app do
          rm_file "spec/spec_helper.rb"
          touch_file "test/test_helper.rb"

          invoke_then_revoke! Suspenders::CiGenerator

          expect("test/test_helper.rb")
            .to not_match_contents(/SimpleCov.coverage_dir/)
            .and not_match_contents(/SimpleCov.start/)
            .and have_no_syntax_error
        end
      end
    end
  end
end
