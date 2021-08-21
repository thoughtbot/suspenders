require "spec_helper"

RSpec.describe Suspenders::DbOptimizationsGenerator, type: :generator do
  it "generates and destroys bullet" do
    with_fake_app do
      generator = invoke!(Suspenders::DbOptimizationsGenerator, stub_bundler: true)

      expect("Gemfile").to have_no_syntax_error
      expect(generator).to have_bundled.with_gemfile_matching(/bullet/)
      expect("config/environments/development.rb")
        .to have_no_syntax_error.and(match_contents(/Bullet.enable/))

      generator = revoke!(Suspenders::DbOptimizationsGenerator, stub_bundler: true)

      expect("Gemfile").to have_no_syntax_error.and(match_original_file)
      expect(generator).to have_bundled.with_gemfile_not_matching(/bullet/)
      expect("config/environments/development.rb")
        .to have_no_syntax_error.and(match_original_file)
    end
  end
end
