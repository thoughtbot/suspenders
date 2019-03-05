require_relative "base"

module Bulldozer
  class PrmdGenerator < Generators::Base
    def copy_rake_file
      copy_file(
        "schema.rake",
        "lib/tasks/schema.rake",
        force: true
      )
    end
  end
end
