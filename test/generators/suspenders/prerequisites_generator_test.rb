require "test_helper"
require "climate_control"
require "generators/suspenders/prerequisites_generator"

module Suspenders
  module Generators
    class PrerequisitesGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::PrerequisitesGenerator
      destination Rails.root
      teardown :restore_destination

      test "generates .node-version file (from ENV)" do
        ClimateControl.modify NODE_VERSION: "1.2.3" do
          run_generator

          assert_file app_root(".node-version") do |file|
            assert_match(/1\.2\.3/, file)
          end
        end
      end

      test "generates .node-version file (from system)" do
        Object.any_instance.stubs(:`).returns("v1.2.3\n")

        run_generator

        assert_file app_root(".node-version") do |file|
          assert_match(/1\.2\.3/, file)
        end
      end

      test "raises if Node is not installed" do
        Object.any_instance.stubs(:`).returns("")

        assert_raises Suspenders::Generators::NodeNotInstalled::Error do
          run_generator
        end

        assert_no_file app_root(".node-version")
      end

      private

      def restore_destination
        remove_file_if_exists ".node-version"
      end
    end
  end
end
