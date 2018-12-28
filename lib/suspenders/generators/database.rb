require "rails/generators"

module Suspenders
  class DatabaseGenerator < Rails::Generators::Base

    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def add_pg
      gem "pg"
      Bundler.with_clean_env { run "bundle install" }
    end

    def create_db_config
      template 'postgresql_database.yml.erb', 'config/database.yml',
        force: true
    end

    def create_schema
      Bundler.with_clean_env { run "bundle exec rails db:create db:migrate" }
    end

    private 

    def app_name
      Rails.application.class.parent_name.demodulize.underscore.dasherize
    end

  end
end
