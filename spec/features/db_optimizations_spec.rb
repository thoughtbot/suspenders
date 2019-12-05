require "spec_helper"

RSpec.describe "suspenders:db_optimizations", type: :generator do
  it "configures bullet" do
    with_app { generate("suspenders:db_optimizations") }

    expect("Gemfile").to match_contents(/bullet/)
    expect("config/environments/development.rb").to \
      match_contents(/Bullet.enable/)
  end

  it "removes bullet" do
    with_app { destroy("suspenders:db_optimizations") }

    expect("Gemfile").not_to match_contents(/bullet/)
    expect("config/environments/development.rb").not_to \
      match_contents(/Bullet.enable/)
  end
end
