require "test_helper"
require "generators/suspenders/inline_svg_generator"

module Suspenders
  module Generators
    class InlinveSvgGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::InlineSvgGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "raises if API only application" do
        within_api_only_app do
          assert_raises Suspenders::Generators::APIAppUnsupported::Error do
            run_generator
          end

          assert_file app_root("Gemfile") do |file|
            assert_no_match "inline_svg", file
          end
        end
      end

      test "does not raise if API configuration is commented out" do
        within_api_only_app commented_out: true do
          run_generator

          assert_file app_root("Gemfile") do |file|
            assert_match "inline_svg", file
          end
        end
      end

      test "adds gems to Gemfile" do
        expected_output = <<~RUBY
          gem "inline_svg"
        RUBY

        run_generator

        assert_file app_root("Gemfile") do |file|
          assert_match(expected_output, file)
        end
      end

      test "installs gems with Bundler" do
        output = run_generator

        assert_match(/bundle install/, output)
      end

      test "configures raising an error when an SVG file is not found" do
        expected_configuration = file_fixture("inline_svg.rb").read

        run_generator

        assert_file app_root("config/initializers/inline_svg.rb") do |file|
          assert_match(expected_configuration, file)
        end
      end

      private

      def prepare_destination
        touch "Gemfile"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_file_if_exists "config/initializers/inline_svg.rb"
      end
    end
  end
end
