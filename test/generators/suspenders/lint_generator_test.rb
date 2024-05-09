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

          assert_match(/yarn add stylelint eslint@\^8\.9\.0 @thoughtbot\/stylelint-config @thoughtbot\/eslint-config npm-run-all prettier --dev/, output)
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
        expected_content = file_fixture("stylelintrc.json").read

        capture(:stderr) { run_generator }

        assert_file app_root(".stylelintrc.json") do |file|
          assert_equal expected_content, file
        end
      end

      test "configures eslint" do
        expected_content = file_fixture("eslintrc.json").read

        capture(:stderr) { run_generator }

        assert_file app_root(".eslintrc.json") do |file|
          assert_equal expected_content, file
        end
      end

      test "configures prettier" do
        prettierrc = file_fixture("prettierrc.json").read
        prettierignore = file_fixture("prettierignore").read

        capture(:stderr) { run_generator }

        assert_file app_root(".prettierrc") do |file|
          assert_equal prettierrc, file
        end

        assert_file app_root(".prettierignore") do |file|
          assert_equal prettierignore, file
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
        expected_content = file_fixture("erb-lint.yml").read

        capture(:stderr) { run_generator }

        assert_file app_root(".erb-lint.yml") do |file|
          assert_equal expected_content, file
        end
      end

      test "better html configuration" do
        expected_content = file_fixture("better_html.rb").read

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

      test "created package.json if one does not exist" do
        remove_file_if_exists "package.json"

        capture(:stderr) { run_generator }

        assert_file app_root("package.json")
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
