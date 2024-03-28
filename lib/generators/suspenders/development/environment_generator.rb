module Suspenders
  module Generators
    module Development
      class EnvironmentGenerator < Rails::Generators::Base
        def raise_on_missing_translations
          uncomment_lines("config/environments/development.rb", "config.i18n.raise_on_missing_translations = true")
        end

        def annotate_render_view_with_filename
          uncomment_lines("config/environments/development.rb", "config.action_view.annotate_rendered_view_with_filenames = true")
        end
      end
    end
  end
end
