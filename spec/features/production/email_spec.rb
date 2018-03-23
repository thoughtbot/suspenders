require "spec_helper"

RSpec.describe "suspenders:production:email" do
  it "generates the configuration for a production email deployment" do
    with_app { generate("suspenders:production:email") }

    expect("config/smtp.rb").to match_contents(%r{SMTP_SETTINGS\s*=})

    expect("config/environments/production.rb").to \
      match_contents(%r{require.+config/smtp})
    expect("config/environments/production.rb").to \
      match_contents(%r{action_mailer.delivery_method\s*=\s*:smtp})
    expect("config/environments/production.rb").to \
      match_contents(%r{action_mailer.smtp_settings\s*=\s*SMTP_SETTINGS})

    expect("app.json").to contain_json(
      env: {
        SMTP_ADDRESS: { required: true },
        SMTP_DOMAIN: { required: true },
        SMTP_PASSWORD: { required: true },
        SMTP_USERNAME: { required: true },
      },
    )
  end

  it "destroys the configuration for a production email deployment" do
    with_app { destroy("suspenders:production:email") }

    expect("config/smtp.rb").not_to exist_as_a_file

    expect("config/environments/production.rb").not_to \
      match_contents(%r{require.+config/smtp})
    expect("config/environments/production.rb").not_to \
      match_contents(%r{action_mailer.delivery_method\s*=\s*:smtp})
    expect("config/environments/production.rb").not_to \
      match_contents(%r{action_mailer.smtp_settings\s*=\s*SMTP_SETTINGS})

    expect("app.json").not_to contain_json(
      env: {
        SMTP_ADDRESS: { required: true },
        SMTP_DOMAIN: { required: true },
        SMTP_PASSWORD: { required: true },
        SMTP_USERNAME: { required: true },
      },
    )
  end
end
