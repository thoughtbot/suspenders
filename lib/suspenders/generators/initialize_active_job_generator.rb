require "rails/generators"

module Suspenders
  class InitializeActiveJobGenerator < Rails::Generators::Base
    source_root(
      File.expand_path(
        File.join("..", "..", "..", "templates"),
        File.dirname(__FILE__),
      ),
    )

    def initialize_active_job
      copy_file(
        "active_job.rb",
        "config/initializers/active_job.rb",
      )
    end
  end
end
