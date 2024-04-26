module Suspenders
  module Generators
    class LintGenerator < Rails::Generators::Base
      include Suspenders::Generators::Helpers

      source_root File.expand_path("../../templates/lint", __FILE__)
      desc <<~MARKDOWN
        - Uses [@thoughtbot/eslint-config][] for JavaScript linting.
        - Uses [@thoughtbot/stylelint-config][] for CSS linting.
        - Uses [prettier][] for additional linting.
        - Uses [better_html][], [erb_lint][], and [erblint-github][] for ERB linting.
        - Uses [standard][] for Ruby linting.

        **Available Commands**

        - Run `yarn lint` to lint front-end code.
        - Run `yarn fix:prettier` to automatically fix prettier violations.
        - Run `bin/rails standard` to lint ERB and Ruby code.
        - Run `bundle exec standardrb --fix` to fix standard violations.

        [@thoughtbot/eslint-config]: https://github.com/thoughtbot/eslint-config
        [@thoughtbot/stylelint-config]: https://github.com/thoughtbot/stylelint-config
        [prettier]: https://prettier.io
        [better_html]: https://github.com/Shopify/better-html
        [erb_lint]: https://github.com/Shopify/erb-lint
        [erblint-github]: https://github.com/github/erblint-github
        [standard]: https://github.com/standardrb/standard
      MARKDOWN

      def check_package_json
        unless File.exist? Rails.root.join("package.json")
          copy_file "package.json", "package.json"
        end
      end

      # TODO: Remove eslint version pin once the follownig is solved
      # https://github.com/thoughtbot/eslint-config/issues/10
      def install_dependencies
        run "yarn add stylelint eslint@^8.9.0 @thoughtbot/stylelint-config @thoughtbot/eslint-config npm-run-all prettier --dev"
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
        copy_file "stylelintrc.json", ".stylelintrc.json"
      end

      def configure_eslint
        copy_file "eslintrc.json", ".eslintrc.json"
      end

      def configure_prettier
        copy_file "prettierrc", ".prettierrc"
        copy_file "prettierignore", ".prettierignore"
      end

      def configure_erb_lint
        copy_file "erb-lint.yml", ".erb-lint.yml"
        copy_file "config_better_html.yml", "config/better_html.yml"
        copy_file "config_initializers_better_html.rb", "config/initializers/better_html.rb"
        copy_file "erblint.rake", "lib/tasks/erblint.rake"
        template "rubocop.yml.tt", ".rubocop.yml"
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

      private

      def package_json
        Rails.root.join("package.json")
      end
    end
  end
end
