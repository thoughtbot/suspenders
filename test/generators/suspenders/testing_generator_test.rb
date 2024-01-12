require "test_helper"
require "generators/suspenders/testing_generator"

module Suspenders
  module Generators
    class TestingGenerator::ClassOptionTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::TestingGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "has a framework option" do
        option = generator_class.class_options[:framework]

        assert_equal :string, option.type
        assert_not option.required
        assert_equal %w[minitest rspec], option.enum
        assert_equal "minitest", option.default
      end

      test "raises if framework option is unsupported" do
        output = capture(:stderr) { run_generator %w[--framework=unknown] }

        assert_match(/Expected '--framework' to be one of/, output)
      end

      private

      def prepare_destination
        touch "Gemfile"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
      end
    end
  end
end

module Suspenders
  module Generators
    class TestingGenerator::MiniTestTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::TestingGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "adds gems to Gemfile" do
        expected = <<~RUBY
          group :test do
            gem "webmock"
          end
        RUBY

        run_generator %w[--framework=minitest]

        assert_file app_root("Gemfile") do |file|
          assert_match(expected, file)
        end
      end

      test "installs gems with Bundler" do
        output = run_generator %w[--framework=minitest]

        assert_match(/bundle install/, output)
      end

      test "does not run RSpec installation script" do
        output = run_generator %w[--framework=minitest]

        assert_no_match(/generate rspec:install/, output)
      end

      test "does not configure Chromedriver" do
        run_generator %w[--framework=minitest]

        assert_no_file app_root("spec/support/chromedriver.rb")
      end

      test "does not create system spec directory" do
        run_generator %w[--framework=minitest]

        assert_no_file app_root("spec/system/.gitkeep")
      end

      test "configures test helper" do
        expected = <<~RUBY
          ENV["RAILS_ENV"] ||= "test"
          require_relative "../config/environment"
          require "rails/test_help"

          module ActiveSupport
            class TestCase
              include ActionView::Helpers::TranslationHelper
              include ActionMailer::TestCase::ClearTestDeliveries

            end
          end

          WebMock.disable_net_connect!(
            allow_localhost: true,
            allow: "chromedriver.storage.googleapis.com"
          )
        RUBY

        output = run_generator %w[--framework=minitest]

        assert_file app_root("test/test_helper.rb") do |file|
          assert_equal expected, file
        end
      end

      test "configures Action Mailer" do
      end

      test "removes spec directory" do
      end

      def prepare_destination
        touch "Gemfile"
        mkdir "test"
        touch "test/test_helper.rb", content: test_helper
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_dir_if_exists "test"
      end

      def test_helper
        <<~RUBY
          ENV["RAILS_ENV"] ||= "test"
          require_relative "../config/environment"
          require "rails/test_help"

          module ActiveSupport
            class TestCase
            end
          end
        RUBY
      end
    end
  end
end

module Suspenders
  module Generators
    class TestingGenerator::RSpecTest < Rails::Generators::TestCase
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
            gem "shoulda-matchers", "~> 6.0"
            gem "webdrivers"
            gem "webmock"
          end
        RUBY

        run_generator %w[--framework=rspec]

        assert_file app_root("Gemfile") do |file|
          assert_match(expected, file)
        end
      end

      test "installs gems with Bundler" do
        output = run_generator %w[--framework=rspec]

        assert_match(/bundle install/, output)
      end

      test "runs RSpec installation script" do
        output = run_generator %w[--framework=rspec]

        assert_match(/generate rspec:install/, output)
      end

      test "configures rails_helper" do
        touch "spec/rails_helper.rb", content: rails_helper

        run_generator %w[--framework=rspec]

        assert_file "spec/rails_helper.rb" do |file|
          assert_match(/RSpec\.configure do \|config\|\s{3}config\.infer_base_class_for_anonymous_controllers\s*=\s*false/m,
            file)
        end
      end

      test "configures spec_helper" do
        touch "spec/spec_helper.rb", content: spec_helper
        expected = <<~RUBY
          RSpec.configure do |config|
            config.example_status_persistence_file_path = \"tmp/rspec_examples.txt\"
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
            allow: "chromedriver.storage.googleapis.com"
          )
        RUBY

        run_generator %w[--framework=rspec]

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

        run_generator %w[--framework=rspec]

        assert_file app_root("spec/support/chromedriver.rb") do |file|
          assert_equal expected, file
        end
      end

      test "creates system spec directory"do
        run_generator %w[--framework=rspec]

        assert_file app_root("spec/system/.gitkeep")
      end

      test "configures Should Matchers" do
        skip
      end

      test "configures i18n" do
        expected = <<~RUBY
          RSpec.configure do |config|
            config.include ActionView::Helpers::TranslationHelper
          end
        RUBY

        run_generator %w[--framework=rspec]

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

        run_generator %w[--framework=rspec]

        assert_file app_root("spec/support/action_mailer.rb") do |file|
          assert_equal expected, file
        end
      end

      test "removes test directory" do
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
        <<~RUBY
          # This file is copied to spec/ when you run 'rails generate rspec:install'
          require 'spec_helper'
          ENV['RAILS_ENV'] ||= 'test'
          require_relative '../config/environment'
          # Prevent database truncation if the environment is production
          abort("The Rails environment is running in production mode!") if Rails.env.production?
          require 'rspec/rails'
          # Add additional requires below this line. Rails is not loaded until this point!

          # Requires supporting ruby files with custom matchers and macros, etc, in
          # spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
          # run as spec files by default. This means that files in spec/support that end
          # in _spec.rb will both be required and run as specs, causing the specs to be
          # run twice. It is recommended that you do not name files matching this glob to
          # end with _spec.rb. You can configure this pattern with the --pattern
          # option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
          #
          # The following line is provided for convenience purposes. It has the downside
          # of increasing the boot-up time by auto-requiring all files in the support
          # directory. Alternatively, in the individual `*_spec.rb` files, manually
          # require only the support files necessary.
          #
          # Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

          # Checks for pending migrations and applies them before tests are run.
          # If you are not using ActiveRecord, you can remove these lines.
          begin
            ActiveRecord::Migration.maintain_test_schema!
          rescue ActiveRecord::PendingMigrationError => e
            abort e.to_s.strip
          end
          RSpec.configure do |config|
            # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
            config.fixture_path = "#{::Rails.root}/spec/fixtures"

            # If you're not using ActiveRecord, or you'd prefer not to run each of your
            # examples within a transaction, remove the following line or assign false
            # instead of true.
            config.use_transactional_fixtures = true

            # You can uncomment this line to turn off ActiveRecord support entirely.
            # config.use_active_record = false

            # RSpec Rails can automatically mix in different behaviours to your tests
            # based on their file location, for example enabling you to call `get` and
            # `post` in specs under `spec/controllers`.
            #
            # You can disable this behaviour by removing the line below, and instead
            # explicitly tag your specs with their type, e.g.:
            #
            #     RSpec.describe UsersController, type: :controller do
            #       # ...
            #     end
            #
            # The different available types are documented in the features, such as in
            # https://rspec.info/features/6-0/rspec-rails
            config.infer_spec_type_from_file_location!

            # Filter lines from Rails gems in backtraces.
            config.filter_rails_from_backtrace!
            # arbitrary gems may also be filtered via:
            # config.filter_gems_from_backtrace("gem name")
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
