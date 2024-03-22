require "test_helper"
require "generators/suspenders/styles_generator"

module Suspenders
  module Generators
    class StylesGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::StylesGenerator
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

      test "does not raise if API configuration is commented out" do
        within_api_only_app(commented_out: true) do
          run_generator
        end
      end

      test "adds gems to Gemfile" do
        run_generator

        assert_file app_root("Gemfile") do |file|
          assert_match "cssbundling-rails", file
        end
      end

      test "installs gems with Bundler" do
        output = run_generator

        assert_match(/bundle install/, output)
      end

      test "runs install script" do
        output = run_generator

        assert_match(/bin\/rails css:install:postcss/, output)
      end

      test "installs modern-normalize and imports stylesheets" do
        output = run_generator
        application_stylesheet = <<~TEXT
          @import "modern-normalize";
          @import "base.css";
          @import "components.css";
          @import "utilities.css";
        TEXT

        assert_match(/add.*modern-normalize/, output)

        assert_file app_root("app/assets/stylesheets/application.postcss.css") do |file|
          assert_equal application_stylesheet, file
        end
      end

      test "creates stylesheets" do
        run_generator

        assert_file app_root("app/assets/stylesheets/base.css") do |file|
          assert_equal "/* Base Styles */", file
        end
        assert_file app_root("app/assets/stylesheets/components.css") do |file|
          assert_equal "/* Component Styles */", file
        end
        assert_file app_root("app/assets/stylesheets/utilities.css") do |file|
          assert_equal "/* Utility Styles */", file
        end
      end

      test "generator has a custom description" do
        assert_no_match(/Description/, generator_class.desc)
      end

      private

      def prepare_destination
        touch "Gemfile"
        touch "app/assets/stylesheets/application.postcss.css"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_file_if_exists "package.json", root: true
        remove_file_if_exists "yarn.lock", root: true
        remove_file_if_exists "app/assets/stylesheets/application.postcss.css"
        remove_file_if_exists "app/assets/stylesheets/base.css"
        remove_file_if_exists "app/assets/stylesheets/components.css"
        remove_file_if_exists "app/assets/stylesheets/utilities.css"
      end
    end
  end
end
