require "test_helper"
require "generators/suspenders/styles_generator"

module Suspenders
  module Generators
    class StylesGenerator::DefaultTest < Rails::Generators::TestCase
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

      test "generator has a description" do
        description = <<~TEXT
          Configures applications to use PostCSS or Tailwind via cssbundling-rails.
          Defaults to PostCSS with modern-normalize, with the option to override via
          --css=tailwind.

          Also creates additional stylesheets if using PostCSS.
        TEXT

        assert_equal description, generator_class.desc
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

    class StylesGenerator::ClassOptionTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::StylesGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "has a css option" do
        option = generator_class.class_options[:css]

        assert_equal :string, option.type
        assert_not option.required
        assert_equal %w[tailwind postcss], option.enum
        assert_equal "postcss", option.default
      end

      test "raises if css option is unsupported" do
        output = capture(:stderr) { run_generator %w[--css=unknown] }

        assert_match(/Expected '--css' to be one of/, output)
      end

      private

      def prepare_destination
        touch "Gemfile"
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

    class StylesGenerator::TailwindTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::StylesGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "runs install script" do
        output = run_generator %w[--css=tailwind]

        assert_match(/bin\/rails css:install:tailwind/, output)
      end

      test "does not install modern-normalize" do
        output = run_generator %w[--css=tailwind]

        assert_no_match(/add.*modern-normalize/, output)
      end

      test "does not create stylesheets" do
        run_generator %w[--css=tailwind]

        assert_no_file app_root("app/assets/stylesheets/base.css")
        assert_no_file app_root("app/assets/stylesheets/components.css")
        assert_no_file app_root("app/assets/stylesheets/utilities.css")
      end

      private

      def prepare_destination
        touch "Gemfile"
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_file_if_exists "package.json", root: true
        remove_file_if_exists "yarn.lock", root: true
        remove_file_if_exists "app/assets/stylesheets/base.css"
        remove_file_if_exists "app/assets/stylesheets/components.css"
        remove_file_if_exists "app/assets/stylesheets/utilities.css"
      end
    end

    class StylesGenerator::PostCssTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::StylesGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "installs modern-normalize and imports stylesheets" do
        output = run_generator %w[--css=postcss]
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

        assert_file app_root("app/assets/stylesheets/base.css")
        assert_file app_root("app/assets/stylesheets/components.css")
        assert_file app_root("app/assets/stylesheets/utilities.css")
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
