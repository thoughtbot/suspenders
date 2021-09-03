require "spec_helper"

RSpec.describe Suspenders::JsonGenerator, type: :generator do
  it "includes a gem for json parsing" do
    with_fake_app do
      invoke! Suspenders::JsonGenerator

      expect("Gemfile")
        .to have_no_syntax_error
        .and have_bundled("install")
        .matching(%r{gem .oj.})
    end
  end

  it "destroys the gem for json parsing" do
    with_fake_app do
      invoke! Suspenders::JsonGenerator
      revoke! Suspenders::JsonGenerator

      expect("Gemfile")
        .to have_no_syntax_error
        .and match_original_file
        .and not_have_bundled
    end
  end
end
