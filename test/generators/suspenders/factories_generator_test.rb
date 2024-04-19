require "test_helper"
require "generators/suspenders/factories_generator"

module Suspenders
  module Generators
    class FactoriesGenerator::DefaultTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::FactoriesGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "installs gem with Bundler" do
        with_test_suite :minitest do
          output = run_generator

          assert_match(/bundle install/, output)
        end
      end

      test "removes fixture definitions" do
        with_test_suite :minitest do
          run_generator

          assert_file app_root("test/test_helper.rb") do |file|
            assert_match(/# fixtures :all/, file)
          end
        end
      end

      test "adds gem to Gemfile" do
        with_test_suite :minitest do
          run_generator

          assert_file app_root("Gemfile") do |file|
            assert_match(/group :development, :test do\n  gem "factory_bot_rails"\nend/, file)
          end
        end
      end

      test "includes syntax methods" do
        with_test_suite :minitest do
          run_generator

          assert_file app_root("test/test_helper.rb") do |file|
            assert_match(/class TestCase\n    include FactoryBot::Syntax::Methods/, file)
          end
        end
      end

      test "creates definition file" do
        with_test_suite :minitest do
          definition_file = file_fixture("factories.rb").read

          run_generator

          assert_file app_root("test/factories.rb") do |file|
            assert_match definition_file, file
          end
        end
      end

      test "creates linting test" do
        with_test_suite :minitest do
          factories_test = file_fixture("factories_test_lint.rb").read

          run_generator

          assert_file app_root("test/factory_bots/factories_test.rb") do |file|
            assert_match factories_test, file
          end
        end
      end

      private

      def prepare_destination
        touch "Gemfile"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_dir_if_exists "lib/tasks"
      end

      def test_helper
        file_fixture("test_helper.rb").read
      end
    end

    class FactoriesGenerator::RSpecTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::FactoriesGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "includes syntax methods" do
        with_test_suite :rspec do
          touch("spec/rails_helper.rb")
          factory_bot_config = <<~RUBY
            FactoryBot.use_parent_strategy = true

            RSpec.configure do |config|
              config.include FactoryBot::Syntax::Methods
            end
          RUBY

          run_generator

          assert_file app_root("spec/support/factory_bot.rb") do |file|
            assert_match factory_bot_config, file
          end
          assert_file app_root("spec/rails_helper.rb") do |file|
            assert_match(/Dir\[Rails\.root\.join\("spec\/support\/\*\*\/\*\.rb"\)\]\.sort\.each { \|file\| require file }/, file)
          end
        end
      end

      test "creates definition file" do
        with_test_suite :rspec do
          definition_file = file_fixture("factories.rb").read

          run_generator

          assert_file app_root("spec/factories.rb") do |file|
            assert_match definition_file, file
          end
        end
      end

      test "does not modify rails_helper if it's configured to include support files" do
        with_test_suite :rspec do
          rails_helper = <<~RUBY
            Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }
          RUBY
          touch "spec/rails_helper.rb", content: rails_helper

          run_generator

          assert_file app_root("spec/rails_helper.rb") do |file|
            assert_equal rails_helper, file
          end
        end
      end

      test "creates linting test" do
        with_test_suite :rspec do
          factories_spec = file_fixture("factories_spec_lint.rb").read

          run_generator

          assert_file app_root("spec/factory_bots/factories_spec.rb") do |file|
            assert_match factories_spec, file
          end
        end
      end

      private

      def prepare_destination
        touch "Gemfile"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_dir_if_exists "lib/tasks"
      end
    end
  end
end
