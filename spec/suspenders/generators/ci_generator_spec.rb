require "spec_helper"

RSpec.describe Suspenders::CiGenerator, type: :generator do
  it "generates and destroys Circle configuration with SimpleCov" do
    with_fake_app do
      invoke! Suspenders::CiGenerator

      expect("Gemfile")
        .to have_bundled("install")
        .matching(/simplecov/)
      expect("spec/spec_helper.rb")
        .to match_contents(/SimpleCov.coverage_dir/)
        .and match_contents(/SimpleCov.start/)
        .and have_no_syntax_error
      expect("circle.yml").to exist_as_a_file

      revoke! Suspenders::CiGenerator

      expect("circle.yml").not_to exist_as_a_file
      expect("spec/spec_helper.rb")
        .to not_match_contents(/SimpleCov/)
        .and have_no_syntax_error
      expect("Gemfile")
        .to have_no_syntax_error
        .and match_original_file
        .and not_have_bundled
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
