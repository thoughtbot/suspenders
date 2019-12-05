require_relative "base"

module Suspenders
  class DbOptimizationsGenerator < Generators::Base
    def add_bullet
      gem "bullet", group: %i(development test)
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_bullet
      inject_template_into_file(
        "config/environments/development.rb",
        "partials/db_optimizations_configuration.rb",
        after: /config.action_mailer.raise_delivery_errors = .*/,
      )
    end
  end
end
