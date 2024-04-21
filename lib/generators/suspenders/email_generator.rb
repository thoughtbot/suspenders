module Suspenders
  module Generators
    class EmailGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/email", __FILE__)
      desc <<~MARKDOWN
        [Intercept][] emails in non-production environments by setting `INTERCEPTOR_ADDRESSES`.

        ```sh
        INTERCEPTOR_ADDRESSES="user_1@example.com,user_2@example.com" bin/rails s
        ```

        Configuration can be found at `config/initializers/email_interceptor.rb`.

        Interceptor can be found at `app/mailers/email_interceptor.rb`.

        [Intercept]: https://guides.rubyonrails.org/action_mailer_basics.html#intercepting-emails
      MARKDOWN

      def create_email_interceptor
        copy_file "email_interceptor.rb", "app/mailers/email_interceptor.rb"
      end

      def create_email_interceptor_initializer
        initializer "email_interceptor.rb", <<~RUBY
          Rails.application.configure do
            if ENV["INTERCEPTOR_ADDRESSES"].present?
              config.action_mailer.interceptors = %w[EmailInterceptor]
            end
          end
        RUBY
      end

      def configure_email_interceptor
        environment do
          %(
            config.to_prepare do
              EmailInterceptor.config.interceptor_addresses = ENV.fetch("INTERCEPTOR_ADDRESSES", "").split(",")
            end
          )
        end
      end

      # TODO: Remove once https://github.com/rails/rails/pull/51191 is in latest
      # Rails release
      def configure_development_environment
        environment %(config.action_mailer.default_url_options = { host: "localhost", port: 3000 }), env: "development"
      end

      # TODO: Remove once https://github.com/rails/rails/pull/51191 is in latest
      # Rails release
      def configure_test_environment
        environment %(config.action_mailer.default_url_options = { host: "www.example.com" }), env: "test"
      end
    end
  end
end
