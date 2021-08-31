require "spec_helper"

RSpec.describe Suspenders::JsonGenerator, type: :generator do
  it "generates and destroy the Gemfile for json parsing" do
    with_fake_app do
      invoke! Suspenders::JsonGenerator

      expect("Gemfile")
        .to have_no_syntax_error
        .and have_bundled("install")
        .matching(%r{gem .oj.})

      revoke!(Suspenders::JsonGenerator, stub_bundler: true)

      expect("Gemfile")
        .to have_no_syntax_error
        .and match_original_file
        .and not_have_bundled
    end
  end
end
