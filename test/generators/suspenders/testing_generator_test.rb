require "test_helper"
require "generators/suspenders/testing_generator"

module Suspenders
  module Generators
    class TestingGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::TestingGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "adds gems to Gemfile" do
        expected = <<~RUBY
            group :development, :test do
              gem "rspec-rails", "~> 6.1.0"
            end

            group :test do
              gem "action_dispatch-testing-integration-capybara", github: "thoughtbot/action_dispatch-testing-integration-capybara", tag: "v0.1.0", require: "action_dispatch/testing/integration/capybara/rspec"
              gem "shoulda-matchers", "~> 6.0"
              gem "webdrivers"
              gem "webmock"
            end
        RUBY

        run_generator

        assert_file app_root("Gemfile") do |file|
          assert_match(expected, file)
        end
      end

      test "installs gems with Bundler" do
        output = run_generator

        assert_match(/bundle install/, output)
      end

      test "runs RSpec installation script" do
        output = run_generator

        assert_match(/generate rspec:install/, output)
      end

      test "configures rails_helper" do
        touch "spec/rails_helper.rb", content: rails_helper

        run_generator

        assert_file "spec/rails_helper.rb" do |file|
          assert_match(/RSpec\.configure do \|config\|\s{3}config\.infer_base_class_for_anonymous_controllers\s*=\s*false/m,
                       file)
        end
      end

      test "configures spec_helper" do
        touch "spec/spec_helper.rb", content: spec_helper
        expected = <<~RUBY
            require "webmock/rspec"

            RSpec.configure do |config|
              config.example_status_persistence_file_path = "tmp/rspec_examples.txt"
              config.order = :random

              config.expect_with :rspec do |expectations|
                expectations.include_chain_clauses_in_custom_matcher_descriptions = true
              end

              config.mock_with :rspec do |mocks|
                mocks.verify_partial_doubles = true
              end
              config.shared_context_metadata_behavior = :apply_to_host_groups
            end

            WebMock.disable_net_connect!(
              allow_localhost: true,
              allow: [
                /(chromedriver|storage)\.googleapis\.com/,
                "googlechromelabs.github.io",
              ]
            )
        RUBY

        run_generator

        assert_file app_root("spec/spec_helper.rb") do |file|
          assert_equal expected, file
        end
      end

      test "configures Chromedriver" do
        expected = <<~RUBY
            require "selenium/webdriver"

            Capybara.register_driver :chrome do |app|
              Capybara::Selenium::Driver.new(app, browser: :chrome)
            end

            Capybara.register_driver :headless_chrome do |app|
              options = ::Selenium::WebDriver::Chrome::Options.new
              options.headless!
              options.add_argument "--window-size=1680,1050"

              Capybara::Selenium::Driver.new app,
                browser: :chrome,
                options: options
            end

            Capybara.javascript_driver = :headless_chrome

            RSpec.configure do |config|
              config.before(:each, type: :system) do
                driven_by :rack_test
              end

              config.before(:each, type: :system, js: true) do
                driven_by Capybara.javascript_driver
              end
            end
        RUBY

        run_generator

        assert_file app_root("spec/support/chromedriver.rb") do |file|
          assert_equal expected, file
        end
      end

      test "creates system spec directory" do
        run_generator

        assert_file app_root("spec/system/.gitkeep")
      end

      test "configures Should Matchers" do
        expected = <<~RUBY
            Shoulda::Matchers.configure do |config|
              config.integrate do |with|
                with.test_framework :rspec
                with.library :rails
              end
            end
        RUBY

        run_generator

        assert_file app_root("spec/support/shoulda_matchers.rb") do |file|
          assert_equal expected, file
        end
      end

      test "configures i18n" do
        expected = <<~RUBY
            RSpec.configure do |config|
              config.include ActionView::Helpers::TranslationHelper
            end
        RUBY

        run_generator

        assert_file app_root("spec/support/i18n.rb") do |file|
          assert_equal expected, file
        end
      end

      test "configures Action Mailer" do
        expected = <<~RUBY
            RSpec.configure do |config|
              config.before(:each) do
                ActionMailer::Base.deliveries.clear
              end
            end
        RUBY

        run_generator

        assert_file app_root("spec/support/action_mailer.rb") do |file|
          assert_equal expected, file
        end
      end

      test "removes test directory" do
        mkdir "test"

        run_generator

        assert_directory app_root("test")
      end

      test "has custom description" do
        skip
      end

      private

      def prepare_destination
        touch "Gemfile"
        mkdir "spec"
        touch "spec/rails_helper.rb"
        touch "spec/spec_helper.rb"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_dir_if_exists "spec"
      end

      def rails_helper
        # Generated from rails g rspec:install
        # Comments removed
        <<~RUBY
            require 'spec_helper'
            ENV['RAILS_ENV'] ||= 'test'
            require_relative '../config/environment'

            abort("The Rails environment is running in production mode!") if Rails.env.production?
            require 'rspec/rails'

            begin
              ActiveRecord::Migration.maintain_test_schema!
            rescue ActiveRecord::PendingMigrationError => e
              abort e.to_s.strip
            end
            RSpec.configure do |config|
              config.fixture_path = "#{::Rails.root}/spec/fixtures"
              config.use_transactional_fixtures = true
              config.infer_spec_type_from_file_location!
              config.filter_rails_from_backtrace!
            end
            Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }
        RUBY
      end

      def spec_helper
        # Generated from rails g rspec:install
        # Comments removed
        <<~RUBY
            RSpec.configure do |config|
              config.expect_with :rspec do |expectations|
                expectations.include_chain_clauses_in_custom_matcher_descriptions = true
              end

              config.mock_with :rspec do |mocks|
                mocks.verify_partial_doubles = true
              end
              config.shared_context_metadata_behavior = :apply_to_host_groups
            end
        RUBY
      end
    end
  end
end
