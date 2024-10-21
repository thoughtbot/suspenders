require "rails/generators"
require_relative "../../generators/suspenders/environments/development_generator"
require_relative "../../generators/suspenders/environments/test_generator"
require_relative "../../generators/suspenders/environments/production_generator"
require_relative "../../generators/suspenders/accessibility_generator"
require_relative "../../generators/suspenders/advisories_generator"
require_relative "../../generators/suspenders/email_generator"
require_relative "../../generators/suspenders/factories_generator"
require_relative "../../generators/suspenders/inline_svg_generator"
require_relative "../../generators/suspenders/jobs_generator"
require_relative "../../generators/suspenders/lint_generator"
require_relative "../../generators/suspenders/styles_generator"
require_relative "../../generators/suspenders/testing_generator"
require_relative "../../generators/suspenders/views_generator"

module Suspenders
  module Cleanup
    class GenerateReadme
      include Suspenders::Generators::Helpers

      def self.perform(readme, app_name)
        new(readme, app_name).perform
      end

      attr_reader :readme, :app_name

      def initialize(readme, app_name)
        @readme = readme
        @app_name = app_name
      end

      def perform
        File.open(readme, "w+") do |file|
          @file = file

          heading app_name.titleize, level: 1

          prerequisites

          local_development

          heading "Configuration", level: 2

          heading "Test", level: 3
          description_for Suspenders::Generators::Environments::TestGenerator

          heading "Development", level: 3
          description_for Suspenders::Generators::Environments::DevelopmentGenerator

          heading "Production", level: 3
          description_for Suspenders::Generators::Environments::ProductionGenerator

          heading "Linting", level: 3
          description_for Suspenders::Generators::LintGenerator

          heading "Testing", level: 2
          description_for Suspenders::Generators::TestingGenerator

          heading "Factories", level: 3
          description_for Suspenders::Generators::FactoriesGenerator

          heading "Accessibility", level: 2
          description_for Suspenders::Generators::AccessibilityGenerator
          content <<~MARKDOWN
            For more information, review the [Accessibility Tooling][] section in
            the [CONTRIBUTING][] guide.

            [Accessibility Tooling]: ./CONTRIBUTING.md#accessibility-tooling
            [CONTRIBUTING]: ./CONTRIBUTING.md
          MARKDOWN
          new_line

          heading "Advisories", level: 2
          description_for Suspenders::Generators::AdvisoriesGenerator

          heading "Mailers", level: 2
          description_for Suspenders::Generators::EmailGenerator

          heading "Jobs", level: 2
          description_for Suspenders::Generators::JobsGenerator

          heading "Layout and Assets", level: 2

          heading "Stylesheets", level: 3
          description_for Suspenders::Generators::StylesGenerator

          heading "Inline SVG", level: 3
          description_for Suspenders::Generators::InlineSvgGenerator

          heading "Layout", level: 3
          description_for Suspenders::Generators::ViewsGenerator
        end
      end

      private

      def content(text)
        @file.write text
      end

      def new_line
        @file.write "\n"
      end

      def heading(text, level:)
        @file.write "#{"#" * level} #{text}\n"
        new_line
      end

      def description_for(generator)
        @file.write generator.desc
        new_line
      end

      def local_development
        @file.write <<~MARKDOWN
          ## Local Development

          ### Initial Setup

          ```
          bin/setup
          ```

          ### Running the Development Server

          ```
          bin/dev
          ```

          ### Seed Data

          - Use `db/seeds.rb` to create records that need to exist in all environments.
          - Use `lib/tasks/dev.rake` to create records that only need to exist in development.

          Running `bin/setup` will run `dev:prime`.

          ### Tasks

          - Use `bin/rails suspenders:db:migrate` to run [database migrations][]. This script ensures they are [reversible][].
          - Use `bin/rails suspenders:cleanup:organize_gemfile` to automatically organize the project's Gemfile.
          - Use `bin/rails default` to run the default Rake task. This will do the following:
            - Run the test suite.
            - Run a Ruby and ERB linter.
            - Scan the Ruby codebase for any dependency vulnerabilities.

          [database migrations]: https://edgeguides.rubyonrails.org/active_record_migrations.html#running-migrations
          [reversible]: https://edgeguides.rubyonrails.org/active_record_migrations.html#making-the-irreversible-possible

        MARKDOWN
      end

      def prerequisites
        heading "Prerequisites", level: 2

        @file.write <<~MARKDOWN
          Ruby: `#{Suspenders::MINIMUM_RUBY_VERSION}`
          Node: `#{node_version}`
        MARKDOWN

        new_line
      end
    end
  end
end
