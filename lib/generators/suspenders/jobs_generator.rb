module Suspenders
  module Generators
    class JobsGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/active_job", __FILE__)
      desc "Installs Sidekiq for background job processing."

      def add_sidekiq_gem
        gem "sidekiq"
        Bundler.with_unbundled_env { run "bundle install" }
      end

      def initialize_active_job
        copy_file "active_job.rb", "config/initializers/active_job.rb"
      end

      def configure_active_job
        environment "config.active_job.queue_adapter = :sidekiq"
        environment "config.action_mailer.deliver_later_queue_name = nil"
        environment "config.action_mailbox.queues.routing = nil"
        environment "config.active_storage.queues.analysis = nil"
        environment "config.active_storage.queues.purge = nil"
        environment "config.active_storage.queues.mirror = nil"
        environment "config.active_job.queue_adapter = :inline", env: "test"
      end

      def configure_procfile
        if Rails.root.join("Procfile.dev").exist?
          append_to_file "Procfile.dev", "worker: bundle exec sidekiq"
        else
          say "Add default Procfile.dev"
          create_file "Procfile.dev", "worker: bundle exec sidekiq"
        end
      end
    end
  end
end
