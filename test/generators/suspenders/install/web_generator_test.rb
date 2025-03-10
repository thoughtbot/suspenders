require "test_helper"
require "generators/suspenders/install/web_generator"

module Suspenders
  module Generators
    module Install
      class WebGeneratorTest < Rails::Generators::TestCase
        include Suspenders::TestHelpers

        tests Suspenders::Generators::Install::WebGenerator
        destination Rails.root
        setup :prepare_destination
        teardown :restore_destination

        test "raises if API only application" do
          within_api_only_app do
            assert_raises Suspenders::Generators::APIAppUnsupported::Error do
              run_generator
            end
          end
        end

        test "raises if PostgreSQL is not the adapter" do
          with_database "unsupported" do
            assert_raises Suspenders::Generators::DatabaseUnsupported::Error do
              run_generator
            end
          end
        end

        test "raises if Node is not installed" do
          Object.any_instance.stubs(:`).returns("")

          with_database "postgresql" do
            assert_raises Suspenders::Generators::NodeNotInstalled::Error do
              run_generator
            end
          end
        end

        test "raises if Node is unsupported" do
          Object.any_instance.stubs(:`).returns("v19.9.9\n")

          with_database "postgresql" do
            assert_raises Suspenders::Generators::NodeVersionUnsupported::Error do
              run_generator
            end
          end
        end

        test "evaluates supported Node versions correctly" do
          web_generator = Generators::Install::WebGenerator.new

          unsupported_versions = %w[1.0.0 1.100.200 10.0.0 19.0.0 19.9.9 19.9999.99999]

          unsupported_versions.each do |unsupported_version|
            Generators::Install::WebGenerator.any_instance.stubs(:node_version).returns(unsupported_version)

            assert_predicate web_generator, :node_version_unsupported?, "Node version #{unsupported_version} should not be supported"
          end

          supported_versions = %w[20.0.0 20.1.0 20.100.200 50.0.0 100.0.0]

          supported_versions.each do |supported_version|
            Generators::Install::WebGenerator.any_instance.stubs(:node_version).returns(supported_version)

            assert_not_predicate web_generator, :node_version_unsupported?, "Node version #{supported_version} should be supported"
          end
        end

        private

        def prepare_destination
          touch "Gemfile"

          File.write("test/dummy/Gemfile", 'source "https://rubygems.org"')
        end

        def restore_destination
          remove_file_if_exists "Gemfile"
        end
      end
    end
  end
end
