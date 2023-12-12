module Suspenders
  module Generators
    class LintGenerator < Rails::Generators::Base
      include Suspenders::Generators::Helpers

      source_root File.expand_path("../../templates/lint", __FILE__)
      desc "Creates a holistic linting solution that covers JavaScript, CSS, Ruby and ERB."

      def install_dependencies
        run "yarn add stylelint@^15.10.1 eslint @thoughtbot/stylelint-config@3.0.0 @thoughtbot/eslint-config npm-run-all prettier --dev"
      end

      def install_gems
        gem_group :development, :test do
          gem "better_html", require: false
          gem "erb_lint", require: false
          gem "erblint-github", require: false
          gem "standard"
        end
        Bundler.with_unbundled_env { run "bundle install" }
      end

      def configure_stylelint
        if using_tailwind?
          copy_file "tailwind.stylelintrc.json", ".stylelintrc.json"
        else
          copy_file "stylelintrc.json", ".stylelintrc.json"
        end
      end

      def configure_eslint
        copy_file "eslintrc.json", ".eslintrc.json"
      end

      def configure_prettier
        copy_file "prettierrc", ".prettierrc"
      end

      def configure_erb_lint
        copy_file "erb-lint.yml", ".erb-lint.yml"
        copy_file "config_better_html.yml", "config/better_html.yml"
        copy_file "config_initializers_better_html.rb", "config/initializers/better_html.rb"
        copy_file "erblint.rake", "lib/tasks/erblint.rake"
        template "rubocop.yml.tt", ".rubocop.yml"

        if default_test_suite?
          copy_file "better_html_test.rb", "test/views/better_html_test.rb"
        elsif rspec_test_suite?
          copy_file "better_html_spec.rb", "spec/views/better_html_spec.rb"
        end
      end

      def update_package_json
        content = File.read package_json
        json = JSON.parse content
        json["scripts"] ||= {}

        json["scripts"]["lint"] = "run-p lint:eslint lint:stylelint lint:prettier"
        json["scripts"]["lint:eslint"] = "eslint --max-warnings=0 --no-error-on-unmatched-pattern 'app/javascript/**/*.js'"
        json["scripts"]["lint:stylelint"] = "stylelint 'app/assets/stylesheets/**/*.css'"
        json["scripts"]["lint:prettier"] = "prettier --check '**/*' --ignore-unknown"
        json["scripts"]["fix:prettier"] = "prettier --write '**/*' --ignore-unknown"

        File.write package_json, JSON.pretty_generate(json)
      end

      # This needs to be the last method definition to ensure everything is
      # properly configured
      def fix_violations
        run "yarn run fix:prettier"
        run "bundle exec rake standard:fix_unsafely"
      end

      private

      def package_json
        Rails.root.join("package.json")
      end
    end
  end
end
