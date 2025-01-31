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
        ClimateControl.modify NODE_VERSION: "20.0.0" do
          run_generator

          assert_file app_root(".node-version") do |file|
            assert_match(/^20\.0\.0$/, file)
          end
        end
      end

      test "#node_version parses out the version number from an alphanumeric value" do
        ClimateControl.modify NODE_VERSION: nil do
          Object.any_instance.stubs(:`).returns("v1.7.4\n")
          actual = Suspenders::Generators::PrerequisitesGenerator.new.node_version

          assert_match(/^1\.7\.4$/, actual)
        end
      end

      test "generates .node-version file (from system)" do
        Generators::PrerequisitesGenerator.any_instance.stubs(:node_version).returns("20.0.0")

        run_generator

        assert_file app_root(".node-version") do |file|
          assert_match(/^20\.0\.0$/, file)
        end
      end

      test "raises if Node is not installed" do
        Generators::PrerequisitesGenerator.any_instance.stubs(:node_version).returns("")

        assert_raises Suspenders::Generators::NodeNotInstalled::Error do
          run_generator
        end

        assert_no_file app_root(".node-version")
      end

      test "raises if Node is unsupported" do
        Generators::PrerequisitesGenerator.any_instance.stubs(:node_version).returns("19.9.9")

        assert_raises Suspenders::Generators::NodeVersionUnsupported::Error do
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
