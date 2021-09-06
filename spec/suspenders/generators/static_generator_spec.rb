require "spec_helper"

RSpec.describe Suspenders::StaticGenerator, type: :generator do
  describe "invoke" do
    it "bundles the high_voltage gem" do
      with_fake_app do
        invoke! Suspenders::StaticGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and have_bundled("install")
          .matching(/high_voltage/)
      end
    end

    it "creates a views/pages/.keep file" do
      with_fake_app do
        invoke! Suspenders::StaticGenerator

        expect("app/views/pages/.keep").to exist_as_a_file
      end
    end
  end

  describe "revoke" do
    it "removes the high_voltage gem from Gemfile" do
      with_fake_app do
        invoke_then_revoke! Suspenders::StaticGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end

    it "deletes the views/pages/.keep file" do
      with_fake_app do
        invoke_then_revoke! Suspenders::StaticGenerator

        expect("app/views/pages/.keep").not_to exist_as_a_file
      end
    end
  end
end
