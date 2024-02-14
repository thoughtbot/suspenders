require "test_helper"
require "generators/suspenders/setup_generator"

module Suspenders
  module Generators
    class SetupGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::SetupGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "modifies bin/setup" do
        expected = bin_setup

        run_generator

        assert_file app_root("bin/setup") do |file|
          assert_equal expected, file
        end
      end

      test "has a custom description" do
        assert_no_match(/Description:/, generator_class.desc)
      end

      private

      def prepare_destination
        backup_file "bin/setup"
      end

      def restore_destination
        remove_file_if_exists "Brewfile"
        restore_file "bin/setup"
        remove_dir_if_exists "lib/tasks"
      end

      def bin_setup
        File.read("./lib/generators/templates/setup/bin_setup.rb")
      end
    end
  end
end
