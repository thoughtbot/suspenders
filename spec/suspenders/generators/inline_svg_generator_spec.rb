require "spec_helper"

RSpec.describe Suspenders::InlineSvgGenerator, type: :generator do
  it "generates and destroys inline_svg" do
    with_fake_app do
      invoke! Suspenders::InlineSvgGenerator

      expect("config/initializers/inline_svg.rb")
        .to have_no_syntax_error
        .and match_contents(/InlineSvg/)
      expect("Gemfile")
        .to have_no_syntax_error
        .and have_bundled("install")
        .matching(/inline_svg/)

      revoke! Suspenders::InlineSvgGenerator

      expect("config/initializers/inline_svg.rb").not_to exist_as_a_file
      expect("Gemfile")
        .to have_no_syntax_error
        .and match_original_file
        .and not_have_bundled
    end
  end
end
