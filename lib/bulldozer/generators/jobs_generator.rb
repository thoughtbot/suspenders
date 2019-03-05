require_relative "base"

module Bulldozer
  class JobsGenerator < Generators::Base
    def add_jobs_gem
      gem "sidekiq"
      Bundler.with_clean_env { run "bundle install" }
    end

    def copy_config_file
      copy_file "sidekiq.yml", "app/config/sidekiq.yml"
    end
    
    def configure_sidekiq_initializer
      configure_application_file(
        "config/initializers/sidekiq.rb",
        configuration
      )
    end

    def configure_active_job
      configure_application_file(
        "config/application.rb",
        "config.active_job.queue_adapter = :sidekiq",
      )
      configure_environment "test", "config.active_job.queue_adapter = :inline"
    end

    private

    def configuration
      <<-RUBY
  # frozen_string_literal: true
  Sidekiq.configure_server do |config|
    config.redis = {
      url: ENV['REDISTOGO_URL'] || ENV['REDIS_URL']
    }
  end
  Sidekiq.configure_client do |config|
    config.redis = {
      url: ENV['REDISTOGO_URL'] || ENV['REDIS_URL']
    }
  end
      RUBY
    end

    def configure_application_file(path, config)
      inject_into_file(
        path,
        "\n    #{config}",
        before: "\n  end",
      )
    end
  end
end
