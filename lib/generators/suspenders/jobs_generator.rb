module Suspenders
  module Generators
    class JobsGenerator < Rails::Generators::Base
      desc <<~MARKDOWN
        Installs Sidekiq for background job processing.
      MARKDOWN

      def add_sidekiq_gem
        gem "sidekiq"
        Bundler.with_unbundled_env { run "bundle install" }
      end

      def configure_active_job
        environment "config.active_job.queue_adapter = :sidekiq"
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
