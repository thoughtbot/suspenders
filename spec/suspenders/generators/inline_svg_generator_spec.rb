require "spec_helper"

RSpec.describe Suspenders::InlineSvgGenerator, type: :generator do
  describe "invoke" do
    it "bundles the inline_svg gem" do
      with_fake_app do
        invoke! Suspenders::InlineSvgGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and have_bundled("install")
          .matching(/inline_svg/)
      end
    end

    it "creates an initializer for inline_svg" do
      with_fake_app do
        invoke! Suspenders::InlineSvgGenerator

        expect("config/initializers/inline_svg.rb")
          .to have_no_syntax_error
          .and match_contents(/InlineSvg/)
      end
    end
  end

  describe "revoke" do
    it "removes the inline_svg gem from Gemfile" do
      with_fake_app do
        invoke_then_revoke! Suspenders::InlineSvgGenerator

        expect("Gemfile")
          .to have_no_syntax_error
          .and match_original_file
          .and not_have_bundled
      end
    end

    it "removes the inline_svg initializer" do
      with_fake_app do
        invoke_then_revoke! Suspenders::InlineSvgGenerator

        expect("config/initializers/inline_svg.rb").not_to exist_as_a_file
      end
    end
  end
end
