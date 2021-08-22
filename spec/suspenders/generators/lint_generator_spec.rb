require "spec_helper"

RSpec.describe Suspenders::LintGenerator, type: :generator do
  it "sets up standard" do
    with_fake_app do
      invoke! Suspenders::LintGenerator

      # standardrb is a Suspenders dependency, so the require of the
      # rake task works and we don't need to fake it
      rake_output = `rake -T`
      expect(rake_output.lines.size).to eq 2
      expect(rake_output.lines[0]).to start_with("rake standard")
      expect(rake_output.lines[1]).to start_with("rake standard:fix")

      expect("Rakefile").to match_contents(%r{require "standard/rake"})
      expect("Gemfile")
        .to match_contents(/gem .standard./)
        .and have_no_syntax_error

      revoke! Suspenders::LintGenerator

      expect(`rake -T`).to be_empty
      expect("Gemfile")
        .to not_match_contents(/gem .standard./)
        .and have_no_syntax_error
    end
  end
end
