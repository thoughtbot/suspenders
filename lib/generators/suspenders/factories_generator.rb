module Suspenders
  module Generators
    class FactoriesGenerator < Rails::Generators::Base
      include Suspenders::Generators::Helpers

      source_root File.expand_path("../../templates/factories", __FILE__)
      desc <<~MARKDOWN
        Uses [FactoryBot][] as an alternative to [Fixtures][] to help you define
        dummy and test data for your test suite. The `create`, `build`, and
        `build_stubbed` class methods are directly available to all tests.

        Place FactoryBot definitions in `spec/factories.rb`, at least until it
        grows unwieldy. This helps reduce confusion around circular dependencies and
        makes it easy to jump between definitions.

        [FactoryBot]: https://github.com/thoughtbot/factory_bot
        [Fixtures]: https://guides.rubyonrails.org/testing.html#the-low-down-on-fixtures
      MARKDOWN

      def add_factory_bot
        gem_group :development, :test do
          gem "factory_bot_rails"
        end

        Bundler.with_unbundled_env { run "bundle install" }
      end

      def set_up_factory_bot
        if default_test_helper_present?
          insert_into_file Rails.root.join("test/test_helper.rb"), after: "class TestCase" do
            "\n    include FactoryBot::Syntax::Methods"
          end
        elsif rspec_test_helper_present?
          copy_file "factory_bot_rspec.rb", "spec/support/factory_bot.rb"
          insert_into_file Rails.root.join("spec/rails_helper.rb") do
            %(Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file })
          end
        end
      end

      def generate_empty_factories_file
        if default_test_suite?
          copy_file "factories.rb", "test/factories.rb"
        elsif rspec_test_suite?
          copy_file "factories.rb", "spec/factories.rb"
        end
      end

      def remove_fixture_definitions
        if default_test_helper_present?
          comment_lines "test/test_helper.rb", /fixtures :all/
        end
      end

      def create_linting_test
        if default_test_suite?
          copy_file "factories_test.rb", "test/factory_bots/factories_test.rb"
        elsif rspec_test_suite?
          copy_file "factories_spec.rb", "spec/factory_bots/factories_spec.rb"
        end
      end
    end
  end
end
