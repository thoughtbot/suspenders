module Suspenders
  module Generators
    module Environments
      class DevelopmentGenerator < Rails::Generators::Base
        desc <<~MARKDOWN
          - Enables [raise_on_missing_translations][].
          - Enables [annotate_rendered_view_with_filenames][].
          - Enables [i18n_customize_full_message][].
          - Enables [query_log_tags_enabled][].

          [raise_on_missing_translations]: https://guides.rubyonrails.org/configuring.html#config-i18n-raise-on-missing-translations
          [annotate_rendered_view_with_filenames]: https://guides.rubyonrails.org/configuring.html#config-action-view-annotate-rendered-view-with-filenames
          [i18n_customize_full_message]: https://guides.rubyonrails.org/configuring.html#config-active-model-i18n-customize-full-message
          [query_log_tags_enabled]: https://guides.rubyonrails.org/configuring.html#config-active-record-query-log-tags-enabled
        MARKDOWN

        def raise_on_missing_translations
          if development_config.match?(/^\s#\s*config\.i18n\.raise_on_missing_translations/)
            uncomment_lines "config/environments/development.rb", "config.i18n.raise_on_missing_translations = true"
          else
            environment %(config.i18n.raise_on_missing_translations = true), env: "development"
          end
        end

        def annotate_render_view_with_filename
          if development_config.match?(/^\s#\s*config\.action_view\.annotate_render_view_with_filename/)
            uncomment_lines "config/environments/development.rb",
              "config.action_view.annotate_rendered_view_with_filenames = true"
          else
            environment %(config.action_view.annotate_rendered_view_with_filenames = true), env: "development"
          end
        end

        def enable_i18n_customize_full_message
          environment %(config.active_model.i18n_customize_full_message = true), env: "development"
        end

        def enable_query_log_tags_enabled
          environment %(config.active_record.query_log_tags_enabled = true), env: "development"
        end

        private

        def development_config
          File.read(Rails.root.join("config/environments/development.rb"))
        end
      end
    end
  end
end
