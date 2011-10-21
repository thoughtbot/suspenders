require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Suspenders
  class Generator < Rails::Generators::AppGenerator
    # let's use postgres by default
    class_option :database,       :type => :string, :aliases => "-d", :default => "postgresql",
                                  :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"
    # no Test::Unit by default
    class_option :skip_test_unit, :type => :boolean, :aliases => "-T", :default => true,
                                  :desc => "Skip Test::Unit files"

    def finish_template
      invoke :suspenders_customization
      super
    end

    def suspenders_customization
      invoke :remove_files_we_dont_need
      invoke :setup_staging
      invoke :create_suspenders_views
      invoke :create_common_javascripts
      invoke :add_jquery_ui
      invoke :setup_database
      invoke :customize_gemfile
      invoke :configure_app
      invoke :setup_stylesheets
      invoke :setup_gitignore
      invoke :copy_miscellaneous_files
      invoke :setup_root_route
      invoke :migrate_database
      invoke :outro
    end

    def remove_files_we_dont_need
      build(:remove_public_index)
      build(:remove_public_images_rails)
    end

    def setup_staging
      say "Setting up the staging environment"
      build(:setup_staging)
    end

    def create_suspenders_views
      say "Creating suspenders views"
      build(:create_views_shared)
      build(:create_shared_flashes)
      build(:create_shared_javascripts)
      build(:create_application_layout)
    end

    def create_common_javascripts
      say "Pulling in some common javascripts"
      build(:create_common_javascripts)
    end

    def add_jquery_ui
      say "Add jQuery ui to the standard application.js"
      build(:add_jquery_ui)
    end

    def setup_database
      say "Setting up database"
      if 'postgresql' == options[:database]
        build(:use_postgres_config_template)
      end
      build(:create_database)
    end

    def customize_gemfile
      build(:include_custom_gems)
    end

    def configure_app
      say "Configuring app"
      build(:configure_rspec)
      build(:configure_action_mailer)
      build(:generate_rspec)
      build(:generate_cucumber)
      build(:generate_clearance)
      build(:install_factory_girl_steps)
    end

    def setup_stylesheets
      say "Set up stylesheets"
      build(:setup_stylesheets)
    end

    def setup_gitignore
      say "Ignore the right files"
      build(:gitignore_files)
    end

    def copy_miscellaneous_files
      say "Copying miscellaneous support files"
      build(:copy_miscellaneous_files)
    end

    def setup_root_route
      say "Setting up a root route"
      build(:setup_root_route)
    end

    def migrate_database
      say "Migrating database"
      build(:migrate_database)
    end

    def outro
      say "Congratulations! You just pulled our suspenders."
      say "Remember to run 'rails generate airbrake' with your API key."
    end

    protected
    def get_builder_class
      Suspenders::AppBuilder
    end

  end
end


