require "rails/generators"

module Suspenders
  class LintGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def set_up_hound
      copy_file "hound.yml", ".hound.yml"
    end
  end
end
