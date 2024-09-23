module Suspenders
  module Generators
    class TestingGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/testing", __FILE__)
      desc <<~MARKDOWN
        Uses [RSpec][] and [RSpec Rails][] in favor of the [default test suite][].

        The test suite can be run with `bin/rails spec`.

        Configuration can be found in the following files:

        ```
        spec/rails_helper.rb
        spec/spec_helper.rb
        spec/support/action_mailer.rb
        spec/support/driver.rb
        spec/support/i18n.rb
        spec/support/shoulda_matchers.rb
        ```

        - Uses [action_dispatch-testing-integration-capybara][] to introduce Capybara assertions into Request specs.
        - Uses [shoulda-matchers][] for simple one-liner tests for common Rails functionality.
        - Uses [webmock][] for stubbing and setting expectations on HTTP requests in Ruby.

        [RSpec]: http://rspec.info
        [RSpec Rails]: https://github.com/rspec/rspec-rails
        [default test suite]: https://guides.rubyonrails.org/testing.html
        [action_dispatch-testing-integration-capybara]: https://github.com/thoughtbot/action_dispatch-testing-integration-capybara
        [shoulda-matchers]: https://github.com/thoughtbot/shoulda-matchers
        [webmock]: https://github.com/bblimke/webmock
      MARKDOWN

      def add_gems
        gem_group :development, :test do
          gem "rspec-rails", "~> 6.1.0"
        end

        gem_group :test do
          gem "capybara"
          gem "action_dispatch-testing-integration-capybara",
            github: "thoughtbot/action_dispatch-testing-integration-capybara", tag: "v0.1.1",
            require: "action_dispatch/testing/integration/capybara/rspec"
          gem "selenium-webdriver"
          gem "shoulda-matchers", "~> 6.0"
          gem "webmock"
        end

        Bundler.with_unbundled_env { run "bundle install" }
      end

      def run_rspec_installation_script
        rails_command "generate rspec:install"
      end

      def modify_rails_helper
        insert_into_file "spec/rails_helper.rb",
          "\s\sconfig.infer_base_class_for_anonymous_controllers = false\n",
          after: "RSpec.configure do |config|\n"

        uncomment_lines "spec/rails_helper.rb", /Rails\.root\.glob/
      end

      def modify_spec_helper
        persistence_file_path = "\s\sconfig.example_status_persistence_file_path = \"tmp/rspec_examples.txt\"\n"
        order = "\s\sconfig.order = :random\n\n"
        webmock_config = <<~RUBY

          WebMock.disable_net_connect!(
            allow_localhost: true,
            allow: [
              /(chromedriver|storage).googleapis.com/,
              "googlechromelabs.github.io"
            ]
          )
        RUBY

        insert_into_file "spec/spec_helper.rb",
          persistence_file_path + order,
          after: "RSpec.configure do |config|\n"

        insert_into_file "spec/spec_helper.rb", "require \"webmock/rspec\"\n\n", before: "RSpec.configure do |config|"
        insert_into_file "spec/spec_helper.rb", webmock_config
      end

      def create_system_spec_dir
        empty_directory "spec/system"
        create_file "spec/system/.gitkeep"
      end

      def configure_chromedriver
        copy_file "driver.rb", "spec/support/driver.rb"
      end

      def configure_i18n_helper
        copy_file "i18n.rb", "spec/support/i18n.rb"
      end

      def configure_shoulda_matchers
        copy_file "shoulda_matchers.rb", "spec/support/shoulda_matchers.rb"
      end

      def configure_action_mailer_helpers
        # https://guides.rubyonrails.org/testing.html#the-basic-test-case
        #
        # The ActionMailer::Base.deliveries array is only reset automatically in
        # ActionMailer::TestCase and ActionDispatch::IntegrationTest tests. If
        # you want to have a clean slate outside these test cases, you can reset
        # it manually with: ActionMailer::Base.deliveries.clear
        copy_file "action_mailer.rb", "spec/support/action_mailer.rb"
      end
    end
  end
end
