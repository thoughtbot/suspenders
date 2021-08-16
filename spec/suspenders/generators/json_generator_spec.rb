require "spec_helper"

RSpec.describe Suspenders::JsonGenerator, type: :generator do
  it "generates the Gemfile for JSON parsing" do
    silence do
      generator = new_invoke_generator(Suspenders::JsonGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect(generator).to have_bundled.with_gemfile_matching(%r{gem .oj.})

      generator = new_revoke_generator(Suspenders::JsonGenerator)
      stub_bundle_install!(generator)
      generator.invoke_all

      expect(generator).to have_bundled.with_gemfile_not_matching(%r{gem .oj.})
      expect("Gemfile").to match_original_file
    end
  end
end
