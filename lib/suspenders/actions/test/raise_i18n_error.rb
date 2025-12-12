require "thor"

module Suspenders
  module Actions
    module Test
      class RaiseI18nError < Thor::Group
        include Thor::Actions

        PATTERN = /config\.i18n\.raise_on_missing_translations = true/
        TARGET_FILE = "config/environments/test.rb"

        argument :app_path

        def self.destination_root
          app_path
        end

        def apply
          uncomment_lines file_path, PATTERN, verbose: false
        end

        def file_path
          File.join(app_path, TARGET_FILE)
        end
      end
    end
  end
end
