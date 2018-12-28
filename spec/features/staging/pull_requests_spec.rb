require "spec_helper"

RSpec.describe "suspenders:staging:pull_requests", type: :generators do
  it "generates the configuration for Heroku pipeline review apps" do
    with_app { generate("suspenders:staging:pull_requests") }

    expect("config/environments/production.rb").to \
      match_contents(%r{HEROKU_APP_NAME})

    expect("bin/setup_review_app").to \
      match_contents(%r{APP_NAME=dummy-app-staging-pr-\$1})
  end

  it "destroys the configuration for Heroku pipeline review apps" do
    with_app { destroy("suspenders:staging:pull_requests") }

    expect("config/environments/production.rb").not_to \
      match_contents(%r{APP_NAME=dummy-app-staging-pr-\$1})

    expect("bin/setup_review_app").not_to exist_as_a_file
  end
end
