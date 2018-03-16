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
  end
end
