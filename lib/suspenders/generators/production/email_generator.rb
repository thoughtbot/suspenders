require "rails/generators"
require_relative "../../actions"

module Suspenders
  module Production
    class EmailGenerator < Rails::Generators::Base
      include Suspenders::Actions

      source_root File.expand_path(
        File.join("..", "..", "..", "..", "templates"),
        File.dirname(__FILE__),
      )

      def smtp_configuration
        copy_file "smtp.rb", "config/smtp.rb"

        prepend_file "config/environments/production.rb",
          %{require Rails.root.join("config/smtp")\n}
      end

      def use_smtp
        config = <<-RUBY

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
        RUBY

        inject_into_file "config/environments/production.rb", config,
          after: "config.action_mailer.perform_caching = false"
      end

      def env_vars
        expand_json(
          "app.json",
          env: {
            SMTP_ADDRESS: { required: true },
            SMTP_DOMAIN: { required: true },
            SMTP_PASSWORD: { required: true },
            SMTP_USERNAME: { required: true },
          },
        )
      end
    end
  end
end
