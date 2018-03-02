require "rails/generators"

module Suspenders
  module Production
    class EmailGenerator < Rails::Generators::Base
      source_root File.expand_path(
        File.join("..", "..", "..", "templates"),
        File.dirname(__FILE__),
      )

      def smtp_configuration
        copy_file "smtp.rb", "config/smtp.rb"

        prepend_file "config/environments/production.rb",
          %{require Rails.root.join("config/smtp")\n\n}
      end

      def use_smtp
        config = <<-RUBY

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
        RUBY

        inject_into_file "config/environments/production.rb", config,
          after: "config.action_mailer.raise_delivery_errors = false"
      end
    end
  end
end
