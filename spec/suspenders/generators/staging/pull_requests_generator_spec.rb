require "spec_helper"

RSpec.describe Suspenders::Staging::PullRequestsGenerator, type: :generator do
  def before_invoke(app_class_name: nil)
    proc { RailsStub.stub_app_class(app_class_name: app_class_name) }
  end

  describe "invoke" do
    it "configures production.rb for heroku" do
      with_fake_app do
        invoke! Suspenders::Staging::PullRequestsGenerator, &before_invoke

        expect("config/environments/production.rb")
          .to match_contents(%r{HEROKU_APP_NAME})
      end
    end

    it "adds heroku to bin/setup_review_app with the correct app name" do
      with_fake_app do
        invoke!(
          Suspenders::Staging::PullRequestsGenerator,
          &before_invoke(app_class_name: "DummyApp::Application")
        )

        expect("bin/setup_review_app")
          .to match_contents(%r{APP_NAME=dummy-app-staging-pr-\$1})
      end
    end
  end

  describe "revoke" do
    it "removes heroku from production.rb" do
      with_fake_app do
        invoke_then_revoke!(
          Suspenders::Staging::PullRequestsGenerator,
          &before_invoke
        )

        expect("config/environments/production.rb")
          .not_to match_contents(%r{APP_NAME=dummy-app-staging-pr-\$1})
      end
    end

    it "removes heroku from bin/setup_review_app" do
      with_fake_app do
        invoke_then_revoke!(
          Suspenders::Staging::PullRequestsGenerator,
          &before_invoke
        )

        expect("bin/setup_review_app").not_to exist_as_a_file
      end
    end
  end
end
