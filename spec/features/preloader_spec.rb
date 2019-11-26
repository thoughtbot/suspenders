require "spec_helper"

RSpec.describe "suspenders:preloader", type: :generator do
  it "adds binstubs for Spring" do
    with_app { generate("suspenders:preloader") }

    expect("bin/rails").to match_contents(/spring/)
    expect("config/spring.rb").to exist_as_a_file
    expect("config/environments/test.rb").to \
      match_contents(/config.cache_classes = false/)
    expect("Gemfile").to match_contents(/spring/)
    expect("Gemfile").to match_contents(/spring-watcher-listen/)
  end

  it "removes Spring binstubs" do
    with_app { destroy("suspenders:preloader") }

    expect("config/environments/test.rb").to \
      match_contents(/config.cache_classes = true/)
    expect("config/spring.rb").not_to exist_as_a_file
    expect("bin/rails").not_to match_contents(/spring/)
    expect("Gemfile").not_to match_contents(/spring-watcher-listen/)
    expect("Gemfile").not_to match_contents(/spring/)
  end
end
