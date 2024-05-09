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
          capture(:stderr) { run_generator }
        end
      end

      test "adds gems to Gemfile" do
        capture(:stderr) { run_generator }

        assert_file app_root("Gemfile") do |file|
          assert_match "cssbundling-rails", file
        end
      end

      test "installs gems with Bundler" do
        capture(:stderr) do
          output = run_generator

          assert_match(/bundle install/, output)
        end
      end

      test "runs install script" do
        capture(:stderr) do
          output = run_generator

          assert_match(/bin\/rails css:install:postcss/, output)
        end
      end

      test "installs modern-normalize and imports stylesheets" do
        capture(:stderr) do
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
      end

      test "creates stylesheets" do
        capture(:stderr) { run_generator }

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

      test "installs postcss-url" do
        capture(:stderr) do
          output = run_generator

          assert_match(/add\s*postcss-url/, output)
        end
      end

      test "configures postcss.config.js" do
        expected = file_fixture("postcss.config.js").read

        capture(:stderr) { run_generator }

        assert_file app_root("postcss.config.js") do |file|
          assert_equal expected, file
        end
      end

      test "overrides existing postcss.config.js" do
        touch "postcss.config.js", content: "unexpected"
        expected = file_fixture("postcss.config.js").read

        capture(:stderr) { run_generator }

        assert_file app_root("postcss.config.js") do |file|
          assert_equal expected, file
        end
      end

      test "creates directory to store static assets generated from postcss-url" do
        capture(:stderr) { run_generator }

        assert_file app_root("app/assets/static/.gitkeep")
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
        remove_file_if_exists "postcss.config.js"
        remove_dir_if_exists "app/assets/static"
      end
    end
  end
end
