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

      test "generator has a description" do
        description = <<~TEXT
          Build test data with clarity and ease.

          This uses FactoryBot to help you define dummy and test data for your test
          suite. The `create`, `build`, and `build_stubbed` class methods are directly
          available to all tests.

          We recommend putting FactoryBot definitions in one `spec/factories.rb` (or
          `test/factories`) file, at least until it grows unwieldy. This helps reduce
          confusion around circular dependencies and makes it easy to jump between
          definitions.

          Supports the default test suite and RSpec.
        TEXT

        assert_equal description, FactoriesGenerator.desc
      end

      test "installs gem with Bundler" do
        Bundler.stubs(:with_unbundled_env).yields
        generator.expects(:run).with("bundle install").once

        capture(:stdout) do
          generator.add_factory_bot
        end
      end

      test "removes fixture definitions" do
        touch "test/test_helper.rb", content: test_helper

        run_generator

        assert_file app_root("test/test_helper.rb") do |file|
          assert_match(/# fixtures :all/, file)
        end
      end

      test "adds gem to Gemfile" do
        run_generator

        assert_file app_root("Gemfile") do |file|
          assert_match(/group :development, :test do\n  gem "factory_bot_rails"\nend/, file)
        end
      end

      test "includes syntax methods" do
        touch "test/test_helper.rb", content: test_helper

        run_generator

        assert_file app_root("test/test_helper.rb") do |file|
          assert_match(/class TestCase\n    include FactoryBot::Syntax::Methods/, file)
        end
      end

      test "creates definition file" do
        definition_file = file_fixture("factories.rb").read

        run_generator

        assert_file app_root("test/factories.rb") do |file|
          assert_match definition_file, file
        end
      end

      test "creates linting test" do
        factories_test = file_fixture("factories_test_lint.rb").read

        run_generator

        assert_file app_root("test/factory_bots/factories_test.rb") do |file|
          assert_match factories_test, file
        end
      end

      private

      def prepare_destination
        mkdir "test"
        touch "Gemfile"
      end

      def restore_destination
        remove_dir_if_exists "test"
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

      test "creates definition file" do
        definition_file = file_fixture("factories.rb").read

        run_generator

        assert_file app_root("spec/factories.rb") do |file|
          assert_match definition_file, file
        end
      end

      test "does not modify rails_helper if it's configured to include support files" do
        rails_helper = <<~RUBY
          Dir[Rails.root.join("spec/support/**/*.rb")].sort.each { |file| require file }
        RUBY
        touch "spec/rails_helper.rb", content: rails_helper

        run_generator

        assert_file app_root("spec/rails_helper.rb") do |file|
          assert_equal rails_helper, file
        end
      end

      test "creates linting test" do
        factories_spec = file_fixture("factories_spec_lint.rb").read

        run_generator

        assert_file app_root("spec/factory_bots/factories_spec.rb") do |file|
          assert_match factories_spec, file
        end
      end

      private

      def prepare_destination
        mkdir "spec"
        touch "spec/spec_helper.rb"
        touch "Gemfile"
      end

      def restore_destination
        remove_dir_if_exists "spec"
        remove_file_if_exists "Gemfile"
        remove_dir_if_exists "lib/tasks"
      end
    end
  end
end
