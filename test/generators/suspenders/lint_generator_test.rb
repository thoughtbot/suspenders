require "test_helper"
require "generators/suspenders/lint_generator"

module Suspenders
  module Generators
    class LintGeneratorTest < Rails::Generators::TestCase
      include Suspenders::TestHelpers

      tests Suspenders::Generators::LintGenerator
      destination Rails.root
      setup :prepare_destination
      teardown :restore_destination

      test "installs dependencies" do
        capture(:stderr) do
          output = run_generator

          assert_match(/yarn add stylelint eslint @thoughtbot\/stylelint-config @thoughtbot\/eslint-config npm-run-all prettier --dev/, output)
        end
      end

      test "installs gems" do
        capture(:stderr) do
          expected_gemfile = <<~TEXT
            group :development, :test do
              gem "better_html", require: false
              gem "erb_lint", require: false
              gem "erblint-github", require: false
              gem "standard"
            end
          TEXT

          output = run_generator

          assert_match(/bundle install/, output)
          assert_file app_root "Gemfile" do |file|
            assert_match expected_gemfile, file
          end
        end
      end

      test "configures stylelint" do
        expected_content = <<~TEXT
          {
            "extends": "@thoughtbot/stylelint-config"
          }
        TEXT

        capture(:stderr) { run_generator }

        assert_file app_root(".stylelintrc.json") do |file|
          assert_equal expected_content, file
        end
      end

      test "configures eslint" do
        expected_content = <<~JSON
          {
            "extends": ["@thoughtbot/eslint-config/prettier"],
            "parserOptions": {
              "ecmaVersion": "latest",
              "sourceType": "module"
            }
          }
        JSON

        capture(:stderr) { run_generator }

        assert_file app_root(".eslintrc.json") do |file|
          assert_equal expected_content, file
        end
      end

      test "configures prettier" do
        expected_content = <<~JSON
          {
            "singleQuote": true,
            "overrides": [
              {
                "files": ["**/*.css", "**/*.scss", "**/*.html"],
                "options": {
                  "singleQuote": false
                }
              }
            ]
          }
        JSON

        capture(:stderr) { run_generator }

        assert_file app_root(".prettierrc") do |file|
          assert_equal expected_content, file
        end

        assert_file app_root(".prettierignore") do |file|
          expected = <<~TEXT
            vendor/bundle/**
          TEXT

          assert_equal expected, file
        end
      end

      test "configures erb-lint" do
        capture(:stderr) { run_generator }

        assert_file app_root(".erb-lint.yml")
        assert_file app_root("config/better_html.yml")
        assert_file app_root("config/initializers/better_html.rb")
        assert_file app_root("lib/tasks/erblint.rake")
      end

      test "erb-lint.yml configuration" do
        expected_content = <<~YAML
          ---
          glob: "app/views/**/*.{html,turbo_stream}{+*,}.erb"

          linters:
            AllowedScriptType:
              enabled: true
              allowed_types:
                - "module"
                - "text/javascript"
            ErbSafety:
              enabled: true
              better_html_config: "config/better_html.yml"
            GitHub::Accessibility::AvoidBothDisabledAndAriaDisabledCounter:
              enabled: true
            GitHub::Accessibility::AvoidGenericLinkTextCounter:
              enabled: true
            GitHub::Accessibility::DisabledAttributeCounter:
              enabled: true
            GitHub::Accessibility::IframeHasTitleCounter:
              enabled: true
            GitHub::Accessibility::ImageHasAltCounter:
              enabled: true
            GitHub::Accessibility::LandmarkHasLabelCounter:
              enabled: true
            GitHub::Accessibility::LinkHasHrefCounter:
              enabled: true
            GitHub::Accessibility::NestedInteractiveElementsCounter:
              enabled: true
            GitHub::Accessibility::NoAriaLabelMisuseCounter:
              enabled: true
            GitHub::Accessibility::NoPositiveTabIndexCounter:
              enabled: true
            GitHub::Accessibility::NoRedundantImageAltCounter:
              enabled: true
            GitHub::Accessibility::NoTitleAttributeCounter:
              enabled: true
            GitHub::Accessibility::SvgHasAccessibleTextCounter:
              enabled: true
            Rubocop:
              enabled: true
              rubocop_config:
                inherit_from:
                  - .rubocop.yml

                Lint/EmptyBlock:
                  Enabled: false
                Layout/InitialIndentation:
                  Enabled: false
                Layout/TrailingEmptyLines:
                  Enabled: false
                Layout/TrailingWhitespace:
                  Enabled: false
                Layout/LeadingEmptyLines:
                  Enabled: false
                Style/FrozenStringLiteralComment:
                  Enabled: false
                Style/MultilineTernaryOperator:
                  Enabled: false
                Lint/UselessAssignment:
                  Exclude:
                    - "app/views/**/*"

          EnableDefaultLinters: true
        YAML

        capture(:stderr) { run_generator }

        assert_file app_root(".erb-lint.yml") do |file|
          assert_equal expected_content, file
        end
      end

      test "better html configuration" do
        expected_content = <<~RUBY
          Rails.configuration.to_prepare do
            if Rails.env.test?
              require "better_html"

              BetterHtml.config = BetterHtml::Config.new(Rails.configuration.x.better_html)

              BetterHtml.config.template_exclusion_filter = proc { |filename| !filename.start_with?(Rails.root.to_s) }
            end
          end
        RUBY

        capture(:stderr) { run_generator }

        assert_file app_root("config/initializers/better_html.rb") do |file|
          assert_equal expected_content, file
        end
      end

      test "generates .rubocop.yml" do
        expected_content = <<~YAML
          AllCops:
            TargetRubyVersion: #{RUBY_VERSION}

          require: standard

          inherit_gem:
            standard: config/base.yml
        YAML

        capture(:stderr) { run_generator }

        assert_file app_root(".rubocop.yml") do |file|
          assert_equal expected_content, file
        end
      end

      test "updates package.json" do
        touch "package.json", content: package_json

        capture(:stderr) { run_generator }

        assert_file "package.json" do |file|
          assert_equal expected_package_json, file
        end
      end

      test "updates package.json if script key does not exist" do
        touch "package.json", content: package_json(empty: true)

        capture(:stderr) { run_generator }

        assert_file "package.json" do |file|
          assert_equal expected_package_json, file
        end
      end

      test "description" do
        desc = "Creates a holistic linting solution that covers JavaScript, CSS, Ruby and ERB."

        assert_equal desc, generator_class.desc
      end

      private

      def prepare_destination
        touch "Gemfile"
        touch "package.json", content: package_json(empty: true)
      end

      def restore_destination
        remove_file_if_exists "Gemfile"
        remove_file_if_exists ".stylelintrc.json"
        remove_file_if_exists ".eslintrc.json"
        remove_file_if_exists ".prettierrc"
        remove_file_if_exists ".prettierignore"
        remove_file_if_exists "package.json"
        remove_file_if_exists ".erb-lint.yml"
        remove_file_if_exists "config/better_html.yml"
        remove_file_if_exists "config/initializers/better_html.rb"
        remove_file_if_exists ".rubocop.yml"
        remove_file_if_exists "package.json", root: true
        remove_file_if_exists "yarn.lock", root: true
        remove_dir_if_exists "lib/tasks"
        remove_dir_if_exists "test"
        remove_dir_if_exists "spec"
      end

      def package_json(empty: false)
        if empty
          <<~JSON.chomp
            {
            }
          JSON
        else
          <<~JSON.chomp
            {
              "scripts": {}
            }
          JSON
        end
      end

      def expected_package_json
        <<~JSON.chomp
          {
            "scripts": {
              "lint": "run-p lint:eslint lint:stylelint lint:prettier",
              "lint:eslint": "eslint --max-warnings=0 --no-error-on-unmatched-pattern 'app/javascript/**/*.js'",
              "lint:stylelint": "stylelint 'app/assets/stylesheets/**/*.css'",
              "lint:prettier": "prettier --check '**/*' --ignore-unknown",
              "fix:prettier": "prettier --write '**/*' --ignore-unknown"
            }
          }
        JSON
      end
    end
  end
end
