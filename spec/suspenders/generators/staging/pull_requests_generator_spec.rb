require "spec_helper"
require "active_support/core_ext/module/introspection"

RSpec.describe Suspenders::Staging::PullRequestsGenerator, type: :generator do
  include RailsStub

  def invoke_pull_requests_generator!(app_class_name: "RandomApp::Application")
    stub_app_class(app_class_name: app_class_name)
    invoke! Suspenders::Staging::PullRequestsGenerator
  end

  def revoke_pull_requests_generator!
    invoke_pull_requests_generator!
    revoke! Suspenders::Staging::PullRequestsGenerator
  end

  describe "invoke" do
    it "configures production.rb for heroku" do
      with_fake_app do
        invoke_pull_requests_generator!

        expect("config/environments/production.rb").to \
          match_contents(%r{HEROKU_APP_NAME})
      end
    end

    it "adds heroku to bin/setup_review_app with the correct app name" do
      with_fake_app do
        invoke_pull_requests_generator!(app_class_name: "DummyApp::Application")

        expect("bin/setup_review_app").to \
          match_contents(%r{APP_NAME=dummy-app-staging-pr-\$1})
      end
    end
  end

  describe "revoke" do
    it "removes heroku from production.rb" do
      with_fake_app do
        revoke_pull_requests_generator!

        expect("config/environments/production.rb").not_to \
          match_contents(%r{APP_NAME=dummy-app-staging-pr-\$1})
      end
    end

    it "removes heroku from bin/setup_review_app" do
      with_fake_app do
        revoke_pull_requests_generator!

        expect("bin/setup_review_app").not_to exist_as_a_file
      end
    end
  end
end
