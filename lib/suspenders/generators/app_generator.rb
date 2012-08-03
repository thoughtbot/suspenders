require 'rails/generators'
require 'rails/generators/rails/app/app_generator'

module Suspenders
  class AppGenerator < Rails::Generators::AppGenerator
    class_option :database, :type => :string, :aliases => '-d', :default => 'postgresql',
      :desc => "Preconfigure for selected database (options: #{DATABASES.join('/')})"

    class_option :skip_test_unit, :type => :boolean, :aliases => '-T', :default => true,
      :desc => 'Skip Test::Unit files'

    class_option :heroku, :type => :boolean, :aliases => '-H', :default => false,
      :desc => 'Create staging and production heroku apps'

    class_option :clearance, :type => :boolean, :aliases => '-C', :default => true,
      :desc => 'Add the clearance Rails authentication library'

    def finish_template
      invoke :suspenders_customization
      super
    end

    def suspenders_customization
      invoke :remove_files_we_dont_need
      invoke :setup_development_environment
      invoke :setup_staging_environment
      invoke :create_suspenders_views
      invoke :create_common_javascripts
      invoke :add_jquery_ui
      invoke :customize_gemfile
      invoke :setup_database
      invoke :configure_app
      invoke :setup_stylesheets
      invoke :copy_miscellaneous_files
      invoke :customize_error_pages
      invoke :remove_routes_comment_lines
      invoke :setup_root_route
      invoke :setup_git
      invoke :create_heroku_apps
      invoke :outro
    end

    def remove_files_we_dont_need
      build :remove_public_index
      build :remove_rails_logo_image
    end

    def setup_development_environment
      say 'Setting up the development environment'
      build :raise_delivery_errors
      build :enable_factory_girl_syntax
    end

    def setup_staging_environment
      say 'Setting up the staging environment'
      build :setup_staging_environment
    end

    def create_suspenders_views
      say 'Creating suspenders views'
      build :create_partials_directory
      build :create_shared_flashes
      build :create_shared_javascripts
      build :create_application_layout
    end

    def create_common_javascripts
      say 'Pulling in some common javascripts'
      build :create_common_javascripts
    end

    def add_jquery_ui
      say 'Add jQuery ui to the standard application.js'
      build :add_jquery_ui
    end

    def customize_gemfile
      build :include_custom_gems

      if options[:clearance]
        build :add_clearance_gem
      end

      bundle_command 'install'
    end

    def setup_database
      say 'Setting up database'

      if 'postgresql' == options[:database]
        build :use_postgres_config_template
      end

      build :create_database
    end

    def configure_app
      say 'Configuring app'
      build :configure_rspec
      build :configure_action_mailer
      build :generate_rspec
      build :generate_cucumber
      build :setup_guard_spork
      build :add_email_validator
      build :setup_default_rake_task
      build :setup_clearance
    end

    def setup_clearance
      if options[:clearance]
        build :generate_clearance
        build :include_clearance_matchers

        if using_active_record?
          build :set_attr_accessibles_on_user
        end
      end
    end

    def setup_stylesheets
      say 'Set up stylesheets'
      build :setup_stylesheets
    end

    def setup_git
      say 'Initializing git'
      invoke :setup_gitignore
      invoke :init_git
    end

    def create_heroku_apps
      if options['heroku']
        say 'Creating heroku apps'
        build :create_heroku_apps
        build :document_heroku
      end
    end

    def setup_gitignore
      build :gitignore_files
    end

    def init_git
      build :init_git
    end

    def copy_miscellaneous_files
      say 'Copying miscellaneous support files'
      build :copy_miscellaneous_files
    end

    def customize_error_pages
      say 'Customizing the 500/404/422 pages'
      build :customize_error_pages
    end

    def remove_routes_comment_lines
      build :remove_routes_comment_lines
    end

    def setup_root_route
      if options[:clearance]
        say 'Setting up a root route'
        build :setup_root_route
      end
    end

    def outro
      say 'Congratulations! You just pulled our suspenders.'
      say "Remember to run 'rails generate airbrake' with your API key."
    end

    def run_bundle
      # Let's not: We'll bundle manually at the right spot
    end

    protected

    def get_builder_class
      Suspenders::AppBuilder
    end

    def using_active_record?
      !options[:skip_active_record]
    end
  end
end
