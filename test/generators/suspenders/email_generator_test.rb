require "test_helper"
require "generators/suspenders/email_generator"

module Suspenders
  module Generators
    class EmailGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::EmailGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "creates a mailer intercepter" do
        expected = <<~RUBY
          class EmailInterceptor
            include ActiveSupport::Configurable

            config_accessor :interceptor_addresses, default: []

            def self.delivering_email(message)
              to = interceptor_addresses

              message.to = to if to.any?
            end
          end
        RUBY

        run_generator

        assert_file app_root("app/mailers/email_interceptor.rb") do |file|
          assert_equal expected, file
        end
      end

      test "creates initializer" do
        expected = <<~RUBY
          Rails.application.configure do
            if ENV["INTERCEPTOR_ADDRESSES"].present?
              config.action_mailer.interceptors = %w[EmailInterceptor]
            end
          end
        RUBY

        run_generator

        assert_file app_root("config/initializers/email_interceptor.rb") do |file|
          assert_equal expected, file
        end
      end

      test "configures application to user email intercepter" do
        run_generator

        assert_file app_root("config/application.rb"), /config\.to_prepare\s*do.\s*EmailInterceptor\.config\.interceptor_addresses\s*=\s*ENV\.fetch\("INTERCEPTOR_ADDRESSES",\s*\"\"\)\.split\(\",\"\).\s*end/m
      end

      test "configures action mailer in development" do
        run_generator

        assert_file app_root("config/environments/development.rb"), /config\.action_mailer\.default_url_options\s*=\s*{\s*host:\s*"localhost",\s*port:\s*3000\s*}/
      end

      test "configures action mailer in test" do
        run_generator

        assert_file app_root("config/environments/test.rb"), /config\.action_mailer\.default_url_options\s*=\s*{\s*host:\s*"www\.example\.com"\s*}/
      end

      test "has custom description" do
        assert_no_match(/Description/, generator_class.desc)
      end

      private

      def prepare_destination
        backup_file "config/application.rb"
        backup_file "config/environments/development.rb"
        backup_file "config/environments/test.rb"
      end

      def restore_destination
        restore_file "config/application.rb"
        restore_file "config/environments/development.rb"
        restore_file "config/environments/test.rb"
        remove_file_if_exists "app/mailers/email_interceptor.rb"
        remove_file_if_exists "config/initializers/email_interceptor.rb"
      end
    end
  end
end
