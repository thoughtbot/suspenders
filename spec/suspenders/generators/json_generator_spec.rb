require "spec_helper"

RSpec.describe Suspenders::JsonGenerator, type: :generator do
  describe "invoke" do
    it "bundles the oj gem" do
      with_fake_app do
        invoke! Suspenders::JsonGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and have_bundled("install")
          .matching(%r{gem .oj.})
      end
    end

    it "creates an initializer for oj" do
      with_fake_app do
        invoke! Suspenders::JsonGenerator

        expect("config/initializers/oj.rb").to match_contents(/Oj.optimize_rails/)
      end
    end
  end

  describe "revoke" do
    it "removes the oj gem from Gemfile" do
      with_fake_app do
        invoke_then_revoke! Suspenders::JsonGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end

    it "destroys the oj initializer" do
      with_fake_app do
        invoke_then_revoke! Suspenders::JsonGenerator

        expect("config/initializers/oj.rb").not_to exist_as_a_file
      end
    end
  end
end
