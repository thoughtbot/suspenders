require "spec_helper"

RSpec.describe "suspenders:production:manifest", type: :generator do
  it "generates the manifest for a production build" do
    with_app { generate("suspenders:production:manifest") }

    expect("app.json").to contain_json(
      name: SuspendersTestHelpers::APP_NAME.dasherize,
      env: {
        APPLICATION_HOST: { required: true },
        AUTO_MIGRATE_DB: { value: "true" },
        EMAIL_RECIPIENTS: { required: true },
        HEROKU_APP_NAME: { required: true },
        HEROKU_PARENT_APP_NAME: { required: true },
        RACK_ENV: { required: true },
        SECRET_KEY_BASE: { generator: "secret" },
      },
    )
  end

  it "destroys the manifest for a production build" do
    with_app { destroy("suspenders:production:manifest") }

    expect("app.json").not_to contain_json(
      name: SuspendersTestHelpers::APP_NAME.dasherize,
      env: {
        APPLICATION_HOST: { required: true },
        AUTO_MIGRATE_DB: { value: "true" },
        EMAIL_RECIPIENTS: { required: true },
        HEROKU_APP_NAME: { required: true },
        HEROKU_PARENT_APP_NAME: { required: true },
        RACK_ENV: { required: true },
        SECRET_KEY_BASE: { generator: "secret" },
      },
    )
  end
end
