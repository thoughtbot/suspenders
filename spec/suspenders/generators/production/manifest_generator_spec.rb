require "spec_helper"
require "active_support/core_ext/module/introspection"

RSpec.describe Suspenders::Production::ManifestGenerator, type: :generator do
  def invoke_manifest_generator!(app_class_name: "RandomApp::Application")
    fake_app_class = Class.new do
      define_singleton_method(:name) { app_class_name }
    end
    allow(Rails).to receive(:app_class).and_return(fake_app_class)
    invoke! Suspenders::Production::ManifestGenerator
  end

  def revoke_manifest_generator!(app_class_name: "RandomApp::Application")
    invoke_manifest_generator!(app_class_name: app_class_name)
    revoke! Suspenders::Production::ManifestGenerator
  end

  describe "invoke" do
    it "generates the manifest for a production build" do
      with_fake_app do
        invoke_manifest_generator! app_class_name: "SomeApp::Application"

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
        revoke_manifest_generator!(app_class_name: "SomeApp::Application")

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
