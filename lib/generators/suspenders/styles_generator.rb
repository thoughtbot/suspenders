module Suspenders
  module Generators
    class StylesGenerator < Rails::Generators::Base
      include Suspenders::Generators::APIAppUnsupported

      CSS_OPTIONS = %w[tailwind postcss].freeze

      class_option :css, enum: CSS_OPTIONS, default: "postcss"
      desc <<~TEXT
        Configures applications to use PostCSS or Tailwind via cssbundling-rails.
        Defaults to PostCSS with modern-normalize, with the option to override via
        --css=tailwind.

        Also creates a directory structure to store additional stylesheets if using
        PostCSS.
      TEXT

      def add_cssbundling_rails_gem
        gem "cssbundling-rails"

        Bundler.with_unbundled_env { run "bundle install" }
        run "bin/rails css:install:#{css}"
      end

      def build_directory_structure
        return if is_tailwind?

        create_file "app/assets/stylesheets/base.css"
        create_file "app/assets/stylesheets/components.css"
        create_file "app/assets/stylesheets/utilities.css"
      end

      # Modify if https://github.com/rails/cssbundling-rails/pull/139 is merged
      def configure_application_stylesheet
        return if is_tailwind?

        run "yarn add modern-normalize"

        append_to_file "app/assets/stylesheets/application.postcss.css" do
          <<~TEXT
            @import "modern-normalize";
            @import "base.css";
            @import "components.css";
            @import "utilities.css";
          TEXT
        end
      end

      private

      def css
        @css ||= options["css"]
      end

      def is_tailwind?
        css == "tailwind"
      end
    end
  end
end
