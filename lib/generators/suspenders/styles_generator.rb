module Suspenders
  module Generators
    class StylesGenerator < Rails::Generators::Base
      include Suspenders::Generators::APIAppUnsupported

      desc <<~MARKDOWN
        Configures application to use PostCSS via cssbundling-rails.

        Adds modern-normalize, and style sheet structure.
      MARKDOWN

      def add_cssbundling_rails_gem
        gem "cssbundling-rails"

        Bundler.with_unbundled_env { run "bundle install" }
        run "bin/rails css:install:postcss"
      end

      def build_directory_structure
        create_file "app/assets/stylesheets/base.css"
        append_to_file "app/assets/stylesheets/base.css", "/* Base Styles */"

        create_file "app/assets/stylesheets/components.css"
        append_to_file "app/assets/stylesheets/components.css", "/* Component Styles */"

        create_file "app/assets/stylesheets/utilities.css"
        append_to_file "app/assets/stylesheets/utilities.css", "/* Utility Styles */"
      end

      def configure_application_stylesheet
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
    end
  end
end
