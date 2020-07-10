require_relative "../base"

module Suspenders
  module Production
    class EmailGenerator < Generators::Base
      def smtp_configuration
        copy_file "smtp.rb", "config/smtp.rb"

        prepend_file "config/environments/production.rb",
          %{require Rails.root.join("config/smtp")\n}
      end

      def use_smtp
        inject_template_into_file(
          "config/environments/production.rb",
          "partials/email_smtp.rb",
          after: "config.action_mailer.perform_caching = false"
        )
      end

      def env_vars
        expand_json(
          "app.json",
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
