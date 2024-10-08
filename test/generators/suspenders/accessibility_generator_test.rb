require "test_helper"
require "generators/suspenders/accessibility_generator"

module Suspenders
  module Generators
    class AccessibilityGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::AccessibilityGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "raises if API only application" do
        within_api_only_app do
          assert_raises Suspenders::Generators::APIAppUnsupported::Error do
            run_generator
          end

          assert_file app_root("Gemfile") do |file|
            assert_no_match "capybara_accessibility_audit", file
            assert_no_match "capybara_accessible_selectors", file
          end
        end
      end

      test "does not raise if API configuration is commented out" do
        within_api_only_app commented_out: true do
          run_generator

          assert_file app_root("Gemfile") do |file|
            assert_match "capybara_accessibility_audit", file
            assert_match "capybara_accessible_selectors", file
          end
        end
      end

      test "adds gems to Gemfile" do
        expected_output = <<~RUBY
          group :test do
            gem "capybara_accessibility_audit", github: "thoughtbot/capybara_accessibility_audit"
            gem "capybara_accessible_selectors", github: "citizensadvice/capybara_accessible_selectors", tag: "v0.12.0"
          end
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

      private

      def prepare_destination
        touch "Gemfile"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
      end
    end
  end
end
