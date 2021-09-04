require "spec_helper"

RSpec.describe Suspenders::Production::ManifestGenerator, type: :generator do
  def before_invoke(app_class_name: nil)
    proc { RailsStub.stub_app_class(app_class_name: app_class_name) }
  end

  describe "invoke" do
    it "generates the manifest for a production build" do
      with_fake_app do
        invoke!(
          Suspenders::Production::ManifestGenerator,
          &before_invoke(app_class_name: "SomeApp::Application")
        )

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
        invoke_then_revoke!(
          Suspenders::Production::ManifestGenerator,
          &before_invoke(app_class_name: "SomeApp::Application")
        )

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
