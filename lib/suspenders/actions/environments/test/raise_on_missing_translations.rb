require "thor/actions"

module Suspenders
  module Actions
    module Environments
      module Test
        class RaiseOnMissingTranslations
          include Thor::Actions

          PATTERN = /config\.i18n\.raise_on_missing_translations = true/
          TARGET_FILE = "config/environments/test.rb"

          attr_reader :destination_root

          def initialize(app_path)
            @destination_root = app_path
            self.behavior = :invoke
          end

          def apply
            uncomment_lines file_path, PATTERN
          end

          def file_path
            File.join(@destination_root, TARGET_FILE)
          end

          private

          def options
            {}
          end

          def relative_to_original_destination_root(path, remove_dot = true)
            path
          end

          def say_status(...)
            # Silence output
          end
        end
      end
    end
  end
end
