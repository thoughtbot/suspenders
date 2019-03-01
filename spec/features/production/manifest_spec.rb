require "spec_helper"

RSpec.describe "bulldozer:production:manifest", type: :generator do
  it "generates the manifest for a production build" do
    with_app { generate("bulldozer:production:manifest") }

    expect("app.json").to contain_json(
      name: BulldozerTestHelpers::APP_NAME.dasherize,
      env: {
        APPLICATION_HOST: { required: true },
        EMAIL_RECIPIENTS: { required: true },
        HEROKU_APP_NAME: { required: true },
        HEROKU_PARENT_APP_NAME: { required: true },
        RACK_ENV: { required: true },
        SECRET_KEY_BASE: { generator: "secret" },
      },
    )
  end

  it "destroys the manifest for a production build" do
    with_app { destroy("bulldozer:production:manifest") }

    expect("app.json").not_to contain_json(
      name: BulldozerTestHelpers::APP_NAME.dasherize,
      env: {
        APPLICATION_HOST: { required: true },
        EMAIL_RECIPIENTS: { required: true },
        HEROKU_APP_NAME: { required: true },
        HEROKU_PARENT_APP_NAME: { required: true },
        RACK_ENV: { required: true },
        SECRET_KEY_BASE: { generator: "secret" },
      },
    )
  end
end
