require_relative "base"

module Bulldozer
  class CommitteeGenerator < Generators::Base
    def copy_config_file
      copy_file(
        "committee.rb",
        "config/initializers/committee.rb",
        force: true
      )
    end
  end
end
