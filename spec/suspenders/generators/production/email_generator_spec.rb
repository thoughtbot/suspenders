require "spec_helper"

RSpec.describe Suspenders::Production::EmailGenerator, type: :generator do
  describe "invoke" do
    it "generates the config/smtp.rb file" do
      with_fake_app do
        invoke! Suspenders::Production::EmailGenerator

        expect("config/smtp.rb").to match_contents(%r{SMTP_SETTINGS\s*=})
      end
    end

    it "adds smtp configuration to production.rb" do
      with_fake_app do
        invoke! Suspenders::Production::EmailGenerator

        contents = read_file("config/environments/production.rb")

        expect(contents)
          .to start_with(%(require Rails.root.join("config/smtp")\n\n))

        expect(contents.lines)
          .to include("  config.action_mailer.delivery_method = :smtp\n")
          .and include("  config.action_mailer.smtp_settings = SMTP_SETTINGS\n")
      end
    end

    it "adds smtp env configuration to app.json" do
      with_fake_app do
        invoke! Suspenders::Production::EmailGenerator

        expect("app.json").to contain_json(
          env: {
            SMTP_ADDRESS: {required: true},
            SMTP_DOMAIN: {required: true},
            SMTP_PASSWORD: {required: true},
            SMTP_USERNAME: {required: true}
          }
        )
      end
    end
  end

  describe "revoke" do
    it "destroys the config/smtp.rb file" do
      with_fake_app do
        invoke_then_revoke! Suspenders::Production::EmailGenerator

        expect("config/smtp.rb").not_to exist_as_a_file
      end
    end

    it "removes smtp configuration from config/smtp.rb" do
      with_fake_app do
        invoke_then_revoke! Suspenders::Production::EmailGenerator

        expect("config/environments/production.rb")
          .to not_match_contents(%r{require.+config/smtp})
          .and not_match_contents(%r{action_mailer.delivery_method\s*=\s*:smtp})
          .and not_match_contents(%r{action_mailer.smtp_settings\s*=\s*SMTP_SETTINGS})
      end
    end

    it "removes smtp env configuration from app.json" do
      with_fake_app do
        invoke_then_revoke! Suspenders::Production::EmailGenerator

        expect("app.json").not_to contain_json(
          env: {
            SMTP_ADDRESS: {required: true},
            SMTP_DOMAIN: {required: true},
            SMTP_PASSWORD: {required: true},
            SMTP_USERNAME: {required: true}
          }
        )
      end
    end
  end
end
