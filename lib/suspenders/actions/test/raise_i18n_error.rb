require "thor"

module Suspenders
  module Actions
    module Test
      class RaiseI18nError < Thor::Group
        include Thor::Actions

        PATTERN = /config\.i18n\.raise_on_missing_translations = true/
        TARGET_FILE = "config/environments/test.rb"

        def apply
          uncomment_lines TARGET_FILE, PATTERN, verbose: false
        end
      end
    end
  end
end
