require "spec_helper"

RSpec.describe Suspenders::InlineSvgGenerator, type: :generator do
  it "generates the configuration for inline_svg" do
    silence do
      generator = new_invoke_generator(Suspenders::InlineSvgGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect("config/initializers/inline_svg.rb").to match_contents(/InlineSvg/)
      expect(generator).to have_bundled.with_gemfile_matching(/inline_svg/)
      expect("Gemfile").to match_contents(/inline_svg/)

      generator = new_revoke_generator(Suspenders::InlineSvgGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect("config/initializers/inline_svg.rb").not_to exist_as_a_file
      expect(generator).to have_bundled.with_gemfile_not_matching(/inline_svg/)
      expect("Gemfile").to match_original_file
    end
  end
end
