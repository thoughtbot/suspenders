module Suspenders
  module Generators
    class JobsGenerator < Rails::Generators::Base
      desc <<~MARKDOWN
        Uses [Sidekiq][] for [background job][] processing.

        Configures the `test` environment to use the [inline][] adapter.

        [Sidekiq]: https://github.com/sidekiq/sidekiq
        [background job]: https://guides.rubyonrails.org/active_job_basics.html
        [inline]: https://api.rubyonrails.org/classes/ActiveJob/QueueAdapters/InlineAdapter.html
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
