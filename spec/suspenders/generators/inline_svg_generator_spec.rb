require "spec_helper"

RSpec.describe Suspenders::InlineSvgGenerator, type: :generator do
  it "generates and destroys inline_svg" do
    with_fake_app do
      generator = invoke!(Suspenders::InlineSvgGenerator, stub_bundler: true)

      expect("config/initializers/inline_svg.rb")
        .to have_no_syntax_error.and(match_contents(/InlineSvg/))
      expect(generator).to have_bundled.with_gemfile_matching(/inline_svg/)
      expect("Gemfile").to match_contents(/inline_svg/)

      generator = revoke!(Suspenders::InlineSvgGenerator, stub_bundler: true)

      expect("config/initializers/inline_svg.rb").not_to exist_as_a_file
      expect("Gemfile").to have_no_syntax_error.and(match_original_file)
      expect(generator).to have_bundled.with_gemfile_not_matching(/inline_svg/)
    end
  end
end
