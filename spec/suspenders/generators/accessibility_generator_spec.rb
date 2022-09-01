require "spec_helper"

RSpec.describe Suspenders::AccessibilityGenerator, type: :generator do
  describe "invoke" do
    it "bundles the capybara_accessibility_audit gem" do
      with_fake_app do
        invoke! Suspenders::AccessibilityGenerator

        expect("Gemfile")
          .to have_bundled("install").matching(/capybara_accessibility_audit/)
          .and have_no_syntax_error
      end
    end

    it "bundles the citizensadvice/capybara_accessible_selectors GitHub repository gem" do
      with_fake_app do
        invoke! Suspenders::AccessibilityGenerator

        expect("Gemfile")
          .to have_bundled("install").matching(/capybara_accessible_selectors/)
          .and have_no_syntax_error
      end
    end
  end

  describe "revoke" do
    it "removes the gems from Gemfile" do
      with_fake_app do
        invoke_then_revoke! Suspenders::AccessibilityGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end
  end
end
