require "spec_helper"

RSpec.describe Suspenders::StaticGenerator, type: :generator do
  it "adds the gem and pages directory" do
    with_fake_app do
      invoke! Suspenders::StaticGenerator

      expect("app/views/pages/.keep").to exist_as_a_file
      expect("Gemfile")
        .to have_no_syntax_error
        .and have_bundled("install")
        .matching(/high_voltage/)

      revoke! Suspenders::StaticGenerator

      expect("app/views/pages/.keep").not_to exist_as_a_file
      expect("Gemfile")
        .to have_no_syntax_error
        .and match_original_file
        .and not_have_bundled
    end
  end
end
