require "spec_helper"

RSpec.describe Suspenders::JsonGenerator, type: :generator do
  it "generates and destroy the Gemfile for json parsing" do
    with_app_dir do
      generator = new_invoke_generator(Suspenders::JsonGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect("Gemfile").to not_have_syntax_error
      expect(generator).to have_bundled.with_gemfile_matching(%r{gem .oj.})

      generator = new_revoke_generator(Suspenders::JsonGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect(generator).to have_bundled.with_gemfile_not_matching(%r{gem .oj.})
      expect("Gemfile").to match_original_file
    end
  end
end
