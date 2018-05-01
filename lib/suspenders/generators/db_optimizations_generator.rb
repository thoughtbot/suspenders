require "rails/generators"

module Suspenders
  class DbOptimizationsGenerator < Rails::Generators::Base
    def add_bullet
      gem "bullet", group: %i(development test)
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_bullet
      inject_into_file(
        "config/environments/development.rb",
        configuration,
        after: "config.action_mailer.raise_delivery_errors = true\n",
      )
    end

    private

    def configuration
      <<-RUBY
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end
      RUBY
    end
  end
end
