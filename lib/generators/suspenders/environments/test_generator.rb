module Suspenders
  module Generators
    module Environments
      class TestGenerator < Rails::Generators::Base
        desc <<~MARKDOWN
          - Enables [raise_on_missing_translations][].
          - Disables [action_dispatch.show_exceptions][].

          [raise_on_missing_translations]: https://guides.rubyonrails.org/configuring.html#config-i18n-raise-on-missing-translations
          [action_dispatch.show_exceptions]: https://edgeguides.rubyonrails.org/configuring.html#config-action-dispatch-show-exceptions
        MARKDOWN

        def raise_on_missing_translations
          if test_config.match?(/^\s*#\s*config\.i18n\.raise_on_missing_translations\s*=\s*true/)
            uncomment_lines "config/environments/test.rb", /config\.i18n\.raise_on_missing_translations\s*=\s*true/
          else
            environment %(config.i18n.raise_on_missing_translations = true), env: "test"
          end
        end

        def disable_action_dispatch_show_exceptions
          if test_config.match?(/^\s*config\.action_dispatch\.show_exceptions\s*=\s*:rescuable/)
            gsub_file "config/environments/test.rb", /^\s*config\.action_dispatch\.show_exceptions\s*=\s*:rescuable/,
              "config.action_dispatch.show_exceptions = :none"
            gsub_file "config/environments/test.rb", /^\s*#\s*Raise exceptions instead of rendering exception templates/i, ""
          else
            environment %(config.action_dispatch.show_exceptions = :none), env: "test"
          end
        end

        private

        def test_config
          File.read(Rails.root.join("config/environments/test.rb"))
        end
      end
    end
  end
end
