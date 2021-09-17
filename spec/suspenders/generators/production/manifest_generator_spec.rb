require "spec_helper"

RSpec.describe Suspenders::Production::ManifestGenerator, type: :generator do
  def setup_rails_stub(app_class_name: nil)
    RailsStub.stub_app_class(app_class_name: app_class_name)
  end

  describe "invoke" do
    it "generates the manifest for a production build" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"

        invoke! Suspenders::Production::ManifestGenerator

        expect("app.json").to contain_json(
          name: "some-app",
          env: {
            APPLICATION_HOST: {required: true},
            AUTO_MIGRATE_DB: {value: true},
            EMAIL_RECIPIENTS: {required: true},
            HEROKU_APP_NAME: {required: true},
            HEROKU_PARENT_APP_NAME: {required: true},
            RACK_ENV: {required: true},
            SECRET_KEY_BASE: {generator: "secret"}
          }
        )
      end
    end
  end

  describe "revoke" do
    it "destroys the manifest for a production build" do
      with_fake_app do
        setup_rails_stub app_class_name: "SomeApp::Application"

        invoke_then_revoke! Suspenders::Production::ManifestGenerator

        expect("app.json").not_to contain_json(
          name: "some-app",
          env: {
            APPLICATION_HOST: {required: true},
            AUTO_MIGRATE_DB: {value: true},
            EMAIL_RECIPIENTS: {required: true},
            HEROKU_APP_NAME: {required: true},
            HEROKU_PARENT_APP_NAME: {required: true},
            RACK_ENV: {required: true},
            SECRET_KEY_BASE: {generator: "secret"}
          }
        )
      end
    end
  end
end
