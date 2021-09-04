require "spec_helper"

RSpec.describe Suspenders::DbOptimizationsGenerator, type: :generator do
  it "generates and destroys bullet" do
    with_fake_app do
      invoke! Suspenders::DbOptimizationsGenerator

      expect("Gemfile")
        .to have_no_syntax_error
        .and have_bundled("install")
        .matching(/bullet/)
      expect("config/environments/development.rb")
        .to have_no_syntax_error
        .and match_contents(/Bullet.enable/)

      revoke! Suspenders::DbOptimizationsGenerator

      expect("Gemfile")
        .to have_no_syntax_error
        .and match_original_file
        .and not_have_bundled
      expect("config/environments/development.rb")
        .to have_no_syntax_error
        .and match_original_file
    end
  end
end
