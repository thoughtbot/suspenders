require "rails/generators"
require_relative "../actions"

module Suspenders
  class JobsGenerator < Rails::Generators::Base
    include Suspenders::Actions

    source_root(
      File.expand_path(
        File.join("..", "..", "..", "templates"),
        File.dirname(__FILE__),
      ),
    )

    def add_jobs_gem
      gem "delayed_job_active_record"
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_background_jobs_for_rspec
      generate "delayed_job:active_record"
    end

    def initialize_active_job
      copy_file(
        "active_job.rb",
        "config/initializers/active_job.rb",
      )
    end

    def configure_active_job
      configure_application_file(
        "config.active_job.queue_adapter = :delayed_job",
      )
      configure_environment "test", "config.active_job.queue_adapter = :inline"
    end

    private

    def configure_application_file(config)
      inject_into_file(
        "config/application.rb",
        "\n    #{config}",
        before: "\n  end",
      )
    end
  end
end
