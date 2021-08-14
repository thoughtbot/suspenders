require "spec_helper"

RSpec.describe Suspenders::DbOptimizationsGenerator, type: :integration do
  it "generates and destroys bullet" do
    generate Suspenders::DbOptimizationsGenerator

    expect("Gemfile").to match_contents(/bullet/)
    expect("config/environments/development.rb").to \
      match_contents(/Bullet.enable/)

    destroy Suspenders::DbOptimizationsGenerator

    expect("Gemfile").not_to match_contents(/bullet/)
    expect("config/environments/development.rb").not_to \
      match_contents(/Bullet.enable/)
  end
end
