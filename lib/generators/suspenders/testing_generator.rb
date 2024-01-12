module Suspenders
  module Generators
    class TestingGenerator < Rails::Generators::Base
      FRAMEWORK_OPTIONS = %w[minitest rspec].freeze

      source_root File.expand_path("../../templates/testing", __FILE__)
      class_option :framework, enum: FRAMEWORK_OPTIONS, default: "minitest"

      def add_gems
        if options[:framework] == "rspec"
          gem_group :development, :test do
            gem "rspec-rails", "~> 6.1.0"
          end

          gem_group :test do
            gem "shoulda-matchers", "~> 6.0"
            gem "webdrivers"
            gem "webmock"
          end
        else
          gem_group :test do
            gem "webmock"
          end
        end

        Bundler.with_unbundled_env { run "bundle install" }
      end

      def run_rspec_installation_script
        if options[:framework] == "rspec"
          rails_command "generate rspec:install"
        end
      end

      def modify_rails_helper
        if options[:framework] == "rspec"
          insert_into_file "spec/rails_helper.rb",
            "  config.infer_base_class_for_anonymous_controllers = false\n",
            after: "RSpec.configure do |config|\n"
        end
      end

      def modify_spec_helper
        if options[:framework] == "rspec"
          persistence_file_path = "  config.example_status_persistence_file_path = \"tmp/rspec_examples.txt\"\n"
          order = "  config.order = :random\n\n"
          webmock_config = <<~RUBY

          WebMock.disable_net_connect!(
            allow_localhost: true,
            allow: "chromedriver.storage.googleapis.com"
          )
          RUBY

          insert_into_file "spec/spec_helper.rb",
            persistence_file_path + order,
            after: "RSpec.configure do |config|\n"

          insert_into_file "spec/spec_helper.rb", webmock_config
        end
      end

      def modify_test_helper
        if options[:framework] == "minitest"
          webmock_config = <<~RUBY

          WebMock.disable_net_connect!(
            allow_localhost: true,
            allow: "chromedriver.storage.googleapis.com"
          )
          RUBY

          insert_into_file "test/test_helper.rb", webmock_config

          insert_into_file "test/test_helper.rb", "\s\s\s\sinclude ActionView::Helpers::TranslationHelper\n\s\s\s\sinclude ActionMailer::TestCase::ClearTestDeliveries\n\n",
            after: "class TestCase\n"
        end
      end

      def create_system_spec_dir
        if options[:framework] == "rspec"
          empty_directory "spec/system"
          create_file "spec/system/.gitkeep"
        end
      end

      def configure_chromedriver
        if options[:framework] == "rspec"
          copy_file "chromedriver.rb", "spec/support/chromedriver.rb"
        end
      end

      def configure_i18n_helper
        if options[:framework] == "rspec"
          copy_file "i18n.rb", "spec/support/i18n.rb"
        end
      end

      def configure_action_mailer_helpers
        # https://guides.rubyonrails.org/testing.html#the-basic-test-case
        #
        # The ActionMailer::Base.deliveries array is only reset automatically in
        # ActionMailer::TestCase and ActionDispatch::IntegrationTest tests. If
        # you want to have a clean slate outside these test cases, you can reset
        # it manually with: ActionMailer::Base.deliveries.clear
        if options[:framework] == "rspec"
          copy_file "action_mailer.rb", "spec/support/action_mailer.rb"
        end
      end
    end
  end
end
