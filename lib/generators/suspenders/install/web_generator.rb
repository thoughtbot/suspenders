module Suspenders
  module Generators
    module Install
      class WebGenerator < Rails::Generators::Base
        include Suspenders::Generators::APIAppUnsupported
        include Suspenders::Generators::DatabaseUnsupported
        include Suspenders::Generators::NodeNotInstalled
        include Suspenders::Generators::NodeVersionUnsupported

        source_root File.expand_path("../../../templates/install/web", __FILE__)
        desc <<~MARKDOWN
          Invokes all necessary generators for new Rails applications generated with Suspenders.

          This generatator is intended to be invoked as part of an [application template][].

          #### Use the latest suspenders release:

          ```
          rails new <app_name> \\
          --skip-rubocop \\
          --skip-test \\
          -d=postgresql \\
          -m=https://raw.githubusercontent.com/thoughtbot/suspenders/main/lib/install/web.rb
          ```

          #### OR use the current (possibly unreleased) `main` branch of suspenders:

          ```
          rails new app_name \\
          --suspenders-main \\
          --skip-rubocop \\
          --skip-test \\
          -d=postgresql \\
          -m=https://raw.githubusercontent.com/thoughtbot/suspenders/main/lib/install/web.rb
          ```

          [application template]: https://guides.rubyonrails.org/rails_application_templates.html
        MARKDOWN

        def invoke_generators
          # This needs to go first, since it configures `.node-version`
          generate "suspenders:prerequisites"

          generate "suspenders:accessibility"
          generate "suspenders:advisories"
          generate "suspenders:email"
          generate "suspenders:factories"
          generate "suspenders:inline_svg"
          generate "suspenders:lint"
          generate "suspenders:rake"
          generate "suspenders:setup"
          generate "suspenders:tasks"
          generate "suspenders:testing"
          generate "suspenders:views"

          # suspenders:jobs needs to be invoked before suspenders:styles, since
          # suspenders:styles generator creates Procfile.dev
          generate "suspenders:styles"
          generate "suspenders:jobs"

          # Needs to run after other generators, since some touch the
          # configuration files.
          generate "suspenders:environments:test"
          generate "suspenders:environments:development"
          generate "suspenders:environments:production"

          # Needs to be run last since it depends on lint, testing, and
          # advisories
          generate "suspenders:ci"
        end

        def cleanup
          rake "suspenders:cleanup:organize_gemfile"
          rake "suspenders:cleanup:generate_readme"
          copy_file "CONTRIBUTING.md", "CONTRIBUTING.md"
        end

        def lint
          run "yarn run fix:prettier"
          run "bundle exec rake standard:fix_unsafely"
        end
      end
    end
  end
end
