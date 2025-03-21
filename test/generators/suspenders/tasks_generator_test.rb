require "test_helper"
require "generators/suspenders/tasks_generator"

module Suspenders
  module Generators
    class TasksGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::TasksGenerator
      destination Rails.root
      teardown :restore_destination

      test "creates development.rake file" do
        Bundler.rubygems.stubs(:find_name).with("factory_bot").returns([true])

        expected = development_rake

        run_generator

        assert_file app_root("lib/tasks/development.rake") do |file|
          assert_equal expected, file
        end
      end

      test "creates Seeder file" do
        Bundler.rubygems.stubs(:find_name).with("factory_bot").returns([true])

        expected = seeder

        run_generator

        assert_file app_root("lib/seeder.rb") do |file|
          assert_equal expected, file
        end
      end

      test "returns early if factory_bot_rails is not installed" do
        output = run_generator

        assert_match(/This generator requires Factory Bot/, output)
        assert_no_file app_root("lib/tasks/development.rake")
      end

      private

      def development_rake
        File.read("./lib/generators/templates/tasks/development.rake")
      end

      def seeder
        File.read("./lib/generators/templates/tasks/seeder.rb")
      end

      def restore_destination
        remove_file_if_exists "lib/tasks/development.rake"
        remove_file_if_exists "lib/seeder.rb"
      end
    end
  end
end
