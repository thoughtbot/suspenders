require_relative "base"

module Suspenders
  class JobsGenerator < Generators::Base
    def add_jobs_gem
      append_file "Gemfile", %(\ngem "sidekiq"\n)
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def initialize_active_job
      copy_file(
        "active_job.rb",
        "config/initializers/active_job.rb"
      )
    end

    def configure_active_job
      configure_application_file("config.active_job.queue_adapter = :sidekiq")
      configure_application_file("config.action_mailer.deliver_later_queue_name = nil")
      configure_application_file("config.action_mailbox.queues.routing = nil")
      configure_application_file("config.active_storage.queues.analysis = nil")
      configure_application_file("config.active_storage.queues.purge = nil")
      configure_application_file("config.active_storage.queues.mirror = nil")
      configure_environment "test", "config.active_job.queue_adapter = :inline"
    end

    private

    def configure_application_file(config)
      inject_into_file(
        "config/application.rb",
        "\n    #{config}",
        before: "\n  end"
      )
    end
  end
end
