require "spec_helper"

RSpec.describe Suspenders::JsonGenerator, type: :generator do
  it "generates and destroy the Gemfile for json parsing" do
    with_app_dir do
      generator = invoke!(Suspenders::JsonGenerator, stub_bundler: true)

      expect("Gemfile").to have_no_syntax_error
      expect(generator).to have_bundled.with_gemfile_matching(%r{gem .oj.})

      generator = revoke!(Suspenders::JsonGenerator, stub_bundler: true)

      expect(generator).to have_bundled.with_gemfile_not_matching(%r{gem .oj.})
      expect("Gemfile").to have_no_syntax_error.and(match_original_file)
    end
  end
end
