module Suspenders
  class AppBuilder < Rails::AppBuilder
    include Suspenders::Actions

    def readme
      copy_file "README.md"
    end

    def remove_public_index
      remove_file 'public/index.html'
    end

    def remove_public_images_rails
      remove_file 'public/images/rails.png'
    end

    def raise_delivery_errors
      replace_in_file "config/environments/development.rb", "raise_delivery_errors = false", "raise_delivery_errors = true"
    end

    def enable_factory_girl_syntax
      copy_file "factory_girl_syntax_rspec.rb", "spec/support/factory_girl.rb"
      copy_file "factory_girl_syntax_cucumber.rb", "features/support/factory_girl.rb"
    end

    def setup_staging_environment
      run "cp config/environments/production.rb config/environments/staging.rb"
    end

    def create_views_shared
      empty_directory "app/views/shared"
    end

    def create_shared_flashes
      copy_file "_flashes.html.erb", "app/views/shared/_flashes.html.erb"
    end

    def create_shared_javascripts
      copy_file "_javascript.html.erb", "app/views/shared/_javascript.html.erb"
    end

    def create_application_layout
      template "suspenders_layout.html.erb.erb",
               "app/views/layouts/application.html.erb",
               :force => true
    end

    def create_common_javascripts
      directory "javascripts", "app/assets/javascripts"
    end

    def add_jquery_ui
      inject_into_file "app/assets/javascripts/application.js", "//= require jquery-ui\n", :before => "//= require_tree ."
    end

    def use_postgres_config_template
      template "postgresql_database.yml.erb", "config/database.yml", :force => true
    end

    def create_database
      bundle_command('exec rake db:create')
    end

    def include_custom_gems
      additions_path = find_in_source_paths 'Gemfile_additions'
      new_gems = File.open(additions_path).read
      inject_into_file("Gemfile", "\n#{new_gems}", :after => /gem 'jquery-rails'/)
    end

    def configure_rspec
      generators_config = <<-RUBY
          config.generators do |generate|
            generate.test_framework :rspec
          end
      RUBY
      inject_into_class "config/application.rb", "Application", generators_config
    end

    def configure_action_mailer
      action_mailer_host "development", "#{app_name}.local"
      action_mailer_host "test",        "example.com"
      action_mailer_host "staging",     "staging.#{app_name}.com"
      action_mailer_host "production",  "#{app_name}.com"
    end

    def generate_rspec
      generate "rspec:install"
      replace_in_file "spec/spec_helper.rb", "# config.mock_with :mocha", "config.mock_with :mocha"
    end

    def generate_cucumber
      generate "cucumber:install", "--rspec", "--capybara"
      inject_into_file "features/support/env.rb",
                       %{Capybara.save_and_open_page_path = 'tmp'\n} +
                       %{Capybara.javascript_driver = :webkit\n},
                       :before => %{Capybara.default_selector = :css}
    end

    def generate_clearance
      generate "clearance:install"
      generate "clearance:features"
    end

    def install_factory_girl_steps
      copy_file "factory_girl_steps.rb", "features/step_definitions/factory_girl_steps.rb"
    end

    def setup_stylesheets
      copy_file "app/assets/stylesheets/application.css", "app/assets/stylesheets/application.css.scss"
      remove_file "app/assets/stylesheets/application.css"
      concat_file "import_scss_styles", "app/assets/stylesheets/application.css.scss"
      create_file "app/assets/stylesheets/_screen.scss"
    end

    def gitignore_files
      concat_file "suspenders_gitignore", ".gitignore"
      ["app/models",
        "app/views/pages",
        "db/migrate",
        "log",
        "public/images",
        "spec/support",
        "spec/lib",
        "spec/models",
        "spec/views",
        "spec/controllers",
        "spec/helpers",
        "spec/support/matchers",
        "spec/support/mixins",
        "spec/support/shared_examples"].each do |dir|
        empty_directory_with_gitkeep dir
      end
    end

    def init_git
      run "git init"
      run "git add -A ."
      run "git commit -m 'Initial commit - suspended project'"
    end

    def create_heroku_apps
      path_additions = ''
      if ENV['TESTING']
        support_bin = File.expand_path(File.join('..', '..', '..', 'features', 'support', 'bin'))
        path_addition = "PATH=#{support_bin}:$PATH"
      end
      run "#{path_addition} heroku create #{app_name}-production --remote=production --stack=cedar"
      run "#{path_addition} heroku create #{app_name}-staging    --remote=staging    --stack=cedar"
    end

    def document_heroku
      heroku_readme_path = find_in_source_paths 'HEROKU_README.md'
      documentation = File.open(heroku_readme_path).read
      inject_into_file("README.md", "#{documentation}\n", :before => "Most importantly")
    end

    def copy_miscellaneous_files
      copy_file "errors.rb", "config/initializers/errors.rb"
      copy_file "time_formats.rb", "config/initializers/time_formats.rb"
      copy_file "Procfile"
    end

    def setup_root_route
      route "root :to => 'Clearance::Sessions#new'"
    end

    def set_active_record_whitelist_attributes
      inject_into_class "config/application.rb", "Application", "    config.active_record.whitelist_attributes = true\n"
    end

    def set_attr_accessibles_on_user
      inject_into_file "app/models/user.rb",
        "  attr_accessible :email, :password\n",
        :after => /include Clearance::User\n/
    end

    def add_email_validator
      copy_file "email_validator.rb", "app/validators/email_validator.rb"
    end

    def include_clearance_matchers
      create_file "spec/support/clearance.rb", "require 'clearance/testing'"
    end

    def setup_default_rake_task
      append_file "Rakefile" do
        "task(:default).clear\ntask :default => [:spec, :cucumber]"
      end
    end

    def add_clearance_gem
      inject_into_file("Gemfile", "\ngem 'clearance'", :after => /gem 'jquery-rails'/)
    end
  end
end
