require "spec_helper"

RSpec.describe Suspenders::LintGenerator, type: :generator do
  # TODO: Should we run rake end-to-end somehow to test the require?
  it "sets up standard" do
    with_app_dir do
      invoke!(Suspenders::LintGenerator)

      expect("Rakefile").to match_contents(%r{require "standard/rake"})
      expect("Gemfile")
        .to match_contents(/gem .standard./).and(have_no_syntax_error)

      revoke!(Suspenders::LintGenerator)

      expect("Rakefile").not_to match_contents(%r{require "standard/rake"})
      expect("Gemfile")
        .to not_match_contents(/gem .standard./).and(have_no_syntax_error)
    end
  end
end
