require "thor"

module Suspenders
  module Actions
    module Test
      class DisableShowDispatchException < Thor::Group
        include Thor::Actions

        PATTERN = /config\.action_dispatch\.show_exceptions = :rescuable/
        TARGET_FILE = "config/environments/test.rb"

        def apply
          comment_lines TARGET_FILE, PATTERN, verbose: false
        end
      end
    end
  end
end
