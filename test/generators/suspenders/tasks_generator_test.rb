require "test_helper"
require "generators/suspenders/tasks_generator"

module Suspenders
  module Generators
    class TasksGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::TasksGenerator
      destination Rails.root
      teardown :restore_destination

      test "creates dev.rake file" do
        Bundler.rubygems.stubs(:find_name).with("factory_bot").returns([true])

        expected = dev_rake

        run_generator

        assert_file app_root("lib/tasks/dev.rake") do |file|
          assert_equal expected, file
        end
      end

      test "returns early if factory_bot_rails is not installed" do
        output = run_generator

        assert_match(/This generator requires Factory Bot/, output)
        assert_no_file app_root("lib/tasks/dev.rake")
      end

      private

      def dev_rake
        File.read("./lib/generators/templates/tasks/dev.rake")
      end

      def restore_destination
        remove_file_if_exists "lib/tasks/dev.rake"
      end
    end
  end
end
