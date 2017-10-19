module Suspenders
  class AppGenerator < Rails::Generators::AppGenerator
    def self.start
      preflight_check
      accept_defaults

      super
    end

    def self.preflight_check
      puts '"bundle install" will be run for the current ruby version and gemset. Press enter to continue...'
      prompt = STDIN.gets.chomp

      unless prompt.empty?
        puts "Skipping install. Please create a ruby gemset first!"
        exit 1
      end
    end

    def self.accept_defaults
      Suspenders::AppBuilder.new.accept_defaults
    end

    def finish_template
      invoke :suspenders_customization
      invoke :update_gemset_in_gemfile
      invoke :bundle_without_production
      invoke :use_slim
      invoke :install_devise
      invoke :customize_application_js
      invoke :require_files_in_lib
      invoke :generate_ruby_version_and_gemset
      invoke :generate_data_migrations
      invoke :add_high_voltage_static_pages
      invoke :add_app_css_file
      invoke :update_application_css_file
      invoke :overwrite_application_layout
      invoke :add_navigation_and_footer
      invoke :generate_test_environment
      invoke :update_test_environment
      invoke :add_rubocop_config
      invoke :add_auto_annotate_models_rake_task
      invoke :add_favicon
      invoke :customize_application_mailer
      invoke :add_specs


      # Do these last
      invoke :add_api_foundation
      invoke :add_administrate
      invoke :rake_db_setup
      invoke :configure_rvm_prepend_bin_to_path
      invoke :configure_sidekiq
      invoke :configure_letter_opener
      invoke :configure_erd
      invoke :run_rubocop_auto_correct
      invoke :copy_env_to_example
      invoke :add_to_gitignore
      invoke :spin_up_webpacker
      invoke :actually_setup_spring
      invoke :bon_voyage
      super
    end

    def update_gemset_in_gemfile
      build :update_gemset_in_gemfile
    end

    def bundle_without_production
      build :bundle_without_production
    end

    def use_slim
      build :use_slim
    end

    def install_devise
      build :install_devise
    end

    def customize_application_js
      build :customize_application_js
    end

    def require_files_in_lib
      build :require_files_in_lib
    end

    def generate_ruby_version_and_gemset
      build :generate_ruby_version_and_gemset
    end

    def generate_data_migrations
      build :generate_data_migrations
    end

    def add_high_voltage_static_pages
      build :add_high_voltage_static_pages
    end

    def add_app_css_file
      build :add_app_css_file
    end

    def update_application_css_file
      build :update_application_css_file
    end

    def overwrite_application_layout
      build :overwrite_application_layout
    end

    def add_navigation_and_footer
      build :add_navigation_and_footer
    end

    def generate_test_environment
      build :generate_test_environment
    end

    def update_test_environment
      build :update_test_environment
    end

    def add_rubocop_config
      build :add_rubocop_config
    end

    def add_auto_annotate_models_rake_task
      build :add_auto_annotate_models_rake_task
    end

    def add_favicon
      build :add_favicon
    end

    def customize_application_mailer
      build :customize_application_mailer
    end

    def add_specs
      build :add_specs
    end

    def spin_up_webpacker
      build :spin_up_webpacker
    end

    def add_api_foundation
      build :add_api_foundation
    end

    def add_administrate
      build :add_administrate
    end

    def rake_db_setup
      build :rake_db_setup
    end

    def configure_rvm_prepend_bin_to_path
      build :configure_rvm_prepend_bin_to_path
    end

    def configure_sidekiq
      build :configure_sidekiq
    end

    def configure_letter_opener
      build :configure_letter_opener
    end

    def configure_erd
      build :configure_erd
    end

    def setup_spring
      # do nothing so we can run generators after suspenders_customization runs
    end

    def run_rubocop_auto_correct
      build :run_rubocop_auto_correct
    end

    def copy_env_to_example
      build :copy_env_to_example
    end

    def add_to_gitignore
      build :add_to_gitignore
    end

    def actually_setup_spring
      say "Springifying binstubs"
      build :setup_spring
    end

    def generate_default
      run('spring stop')
      generate('suspenders:static')

      # NOTE: (2017-06-04) jon => do the junk from the stylesheet_base_generator, but without burbon, neat, bitters
      gem 'refills', group: [:development, :test]
      Bundler.with_clean_env { run 'bundle install' }

      copy_file(
        'application.scss',
        'app/assets/stylesheets/application.scss',
        force: true,
      )

      remove_file 'app/assets/stylesheets/application.css'

      generate 'refills:import', 'flashes'
      remove_dir 'app/views/refills'
    end

    def outro
      # need this to be nothing so it doesn't output any text when
      # :suspenders_customization runs and it invokes this method
    end

    def bon_voyage
      say 'Congratulations! You just pulled our suspenders, Headway style!'
      say honeybadger_outro
    end
  end
end
