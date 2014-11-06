module Suspenders
  class AppBuilder < Rails::AppBuilder
    include Suspenders::Actions

    def readme
      template 'README.md.erb', 'README.md'
    end

    def raise_on_delivery_errors
      replace_in_file 'config/environments/development.rb',
        'raise_delivery_errors = false', 'raise_delivery_errors = true'
    end

    def raise_on_unpermitted_parameters
      config = <<-RUBY
    config.action_controller.action_on_unpermitted_parameters = :raise
      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    def provide_setup_script
      template 'bin_setup.erb', 'bin/setup', port_number: port_number
      run 'chmod a+x bin/setup'
    end

    def provide_dev_prime_task
      copy_file 'development_seeds.rb', 'lib/tasks/development_seeds.rake'
    end

    def configure_generators
      config = <<-RUBY

    config.generators do |generate|
      generate.helper false
      generate.javascript_engine false
      generate.request_specs false
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def set_up_factory_girl_for_rspec
      copy_file 'factory_girl_rspec.rb', 'spec/support/factory_girl.rb'
    end

    def configure_newrelic
      template 'newrelic.yml.erb', 'config/newrelic.yml'
    end

    def configure_smtp
      copy_file 'smtp.rb', 'config/smtp.rb'

      prepend_file 'config/environments/production.rb',
        %{require Rails.root.join("config/smtp")\n}

      config = <<-RUBY

  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = SMTP_SETTINGS
      RUBY

      inject_into_file 'config/environments/production.rb', config,
        :after => 'config.action_mailer.raise_delivery_errors = false'
    end

    def enable_rack_deflater
      config = <<-RUBY

  # Enable deflate / gzip compression of controller-generated responses
  config.middleware.use Rack::Deflater
      RUBY

      inject_into_file 'config/environments/production.rb', config,
        :after => "config.serve_static_assets = false\n"
    end

    def setup_asset_host
      replace_in_file 'config/environments/production.rb',
        '# config.action_controller.asset_host = "http://assets.example.com"',
        'config.action_controller.asset_host = ENV.fetch("ASSET_HOST")'

      replace_in_file 'config/initializers/assets.rb',
        "config.assets.version = '1.0'",
        'config.assets.version = (ENV["ASSETS_VERSION"] || "1.0")'

      replace_in_file 'config/environments/production.rb',
        'config.serve_static_assets = false',
        'config.static_cache_control = "public, max-age=#{1.year.to_i}"'
    end

    def setup_staging_environment
      staging_file = 'config/environments/staging.rb'
      copy_file 'staging.rb', staging_file

      config = <<-RUBY

Rails.application.configure do
  # ...
end
      RUBY

      append_file staging_file, config
    end

    def setup_secret_token
      template 'secrets.yml', 'config/secrets.yml', force: true
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_shared_flashes
      copy_file '_flashes.html.erb', 'app/views/application/_flashes.html.erb'
    end

    def create_shared_javascripts
      copy_file '_javascript.html.erb', 'app/views/application/_javascript.html.erb'
    end

    def create_application_layout
      template 'suspenders_layout.html.erb.erb',
        'app/views/layouts/application.html.erb',
        force: true
    end

    def remove_turbolinks
      replace_in_file 'app/assets/javascripts/application.js',
        /\/\/= require turbolinks\n/,
        ''
    end

    def use_postgres_config_template
      template 'postgresql_database.yml.erb', 'config/database.yml',
        force: true
    end

    def create_database
      bundle_command 'exec rake db:create db:migrate'
    end

    def replace_gemfile
      remove_file 'Gemfile'
      template 'Gemfile.erb', 'Gemfile'
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{Suspenders::RUBY_VERSION}\n"
    end

    def setup_heroku_specific_gems
      inject_into_file 'Gemfile', "\n\s\sgem 'rails_12factor'",
        after: /group :staging, :production do/
    end

    def enable_database_cleaner
      copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
    end

    def configure_spec_support_features
      empty_directory_with_keep_file 'spec/features'
      empty_directory_with_keep_file 'spec/support/features'
    end

    def configure_rspec
      remove_file "spec/rails_helper.rb"
      remove_file "spec/spec_helper.rb"
      copy_file "rails_helper.rb", "spec/rails_helper.rb"
      copy_file "spec_helper.rb", "spec/spec_helper.rb"
    end

    def configure_travis
      template 'travis.yml.erb', '.travis.yml'
    end

    def configure_i18n_for_test_environment
      copy_file "i18n.rb", "spec/support/i18n.rb"
    end

    def configure_i18n_for_missing_translations
      raise_on_missing_translations_in("development")
      raise_on_missing_translations_in("test")
    end

    def configure_i18n_tasks
      run "cp $(i18n-tasks gem-path)/templates/rspec/i18n_spec.rb spec/"
      copy_file "config_i18n_tasks.yml", "config/i18n-tasks.yml"
    end

    def configure_background_jobs_for_rspec
      copy_file 'background_jobs_rspec.rb', 'spec/support/background_jobs.rb'
      run 'rails g delayed_job:active_record'
    end

    def configure_action_mailer_in_specs
      copy_file 'action_mailer.rb', 'spec/support/action_mailer.rb'
    end

    def configure_time_zone
      config = <<-RUBY
    config.active_record.default_timezone = :utc
      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def configure_time_formats
      remove_file "config/locales/en.yml"
      template "config_locales_en.yml.erb", "config/locales/en.yml"
    end

    def configure_rack_timeout
      copy_file 'rack_timeout.rb', 'config/initializers/rack_timeout.rb'
    end

    def configure_action_mailer
      action_mailer_host 'development', "localhost:#{port_number}"
      action_mailer_host 'test', 'www.example.com'
      action_mailer_host 'staging', "staging.#{app_name}.com"
      action_mailer_host 'production', "#{app_name}.com"
    end

    def fix_i18n_deprecation_warning
      config = <<-RUBY
    config.i18n.enforce_available_locales = true
      RUBY

      inject_into_class 'config/application.rb', 'Application', config
    end

    def generate_rspec
      generate 'rspec:install'
    end

    def configure_unicorn
      copy_file 'unicorn.rb', 'config/unicorn.rb'
    end

    def setup_foreman
      copy_file 'sample.env', '.sample.env'
      copy_file 'Procfile', 'Procfile'
    end

    def setup_stylesheets
      remove_file 'app/assets/stylesheets/application.css'
      copy_file 'application.css.scss',
        'app/assets/stylesheets/application.css.scss'
    end

    def install_bitters
      run "bitters install --path app/assets/stylesheets"
    end

    def gitignore_files
      remove_file '.gitignore'
      copy_file 'suspenders_gitignore', '.gitignore'
      [
        'app/views/pages',
        'spec/lib',
        'spec/controllers',
        'spec/helpers',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_examples'
      ].each do |dir|
        run "mkdir #{dir}"
        run "touch #{dir}/.keep"
      end
    end

    def init_git
      run 'git init'
    end

    def create_heroku_apps
      run_heroku "create #{app_name}-production", "production"
      run_heroku "create #{app_name}-staging", "staging"
      run_heroku "config:add RACK_ENV=staging RAILS_ENV=staging", "staging"
    end

    def set_heroku_remotes
      remotes = <<-SHELL

# Set up the staging and production apps.
#{join_heroku_app('staging')}
#{join_heroku_app('production')}
      SHELL

      append_file 'bin/setup', remotes
    end

    def join_heroku_app(environment)
      heroku_app_name = "#{app_name}-#{environment}"
      <<-SHELL
if heroku join --app #{heroku_app_name} &> /dev/null; then
  git remote add #{environment} git@heroku.com:#{heroku_app_name}.git || true
  printf 'You are a collaborator on the "#{heroku_app_name}" Heroku app\n'
else
  printf 'Ask for access to the "#{heroku_app_name}" Heroku app\n'
fi
      SHELL
    end

    def set_heroku_rails_secrets
      %w(staging production).each do |environment|
        run_heroku "config:add SECRET_KEY_BASE=#{generate_secret}", environment
      end
    end

    def set_memory_management_variable
      %w(staging production).each do |environment|
        run_heroku "config:add NEW_RELIC_AGGRESSIVE_KEEPALIVE=1", environment
      end
    end

    def create_github_repo(repo_name)
      path_addition = override_path_for_tests
      run "#{path_addition} hub create #{repo_name}"
    end

    def setup_segment_io
      copy_file '_analytics.html.erb',
        'app/views/application/_analytics.html.erb'
    end

    def copy_miscellaneous_files
      copy_file 'errors.rb', 'config/initializers/errors.rb'
    end

    def customize_error_pages
      meta_tags =<<-EOS
  <meta charset="utf-8" />
  <meta name="ROBOTS" content="NOODP" />
  <meta name="viewport" content="initial-scale=1" />
      EOS

      %w(500 404 422).each do |page|
        inject_into_file "public/#{page}.html", meta_tags, :after => "<head>\n"
        replace_in_file "public/#{page}.html", /<!--.+-->\n/, ''
      end
    end

    def remove_routes_comment_lines
      replace_in_file 'config/routes.rb',
        /Rails\.application\.routes\.draw do.*end/m,
        "Rails.application.routes.draw do\nend"
    end

    def disable_xml_params
      copy_file 'disable_xml_params.rb', 'config/initializers/disable_xml_params.rb'
    end

    def setup_default_rake_task
      append_file 'Rakefile' do
        <<-EOS
task(:default).clear
task default: [:spec]

if defined? RSpec
  task(:spec).clear
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.verbose = false
  end
end
        EOS
      end
    end

    private

    def raise_on_missing_translations_in(environment)
      config = 'config.action_view.raise_on_missing_translations = true'

      uncomment_lines("config/environments/#{environment}.rb", config)
    end

    def override_path_for_tests
      if ENV['TESTING']
        support_bin = File.expand_path(File.join('..', '..', 'spec', 'fakes', 'bin'))
        "PATH=#{support_bin}:$PATH"
      end
    end

    def run_heroku(command, environment)
      path_addition = override_path_for_tests
      run "#{path_addition} heroku #{command} --remote #{environment}"
    end

    def factories_spec_rake_task
      IO.read find_in_source_paths('factories_spec_rake_task.rb')
    end

    def generate_secret
      SecureRandom.hex(64)
    end

    def port_number
      @port_number ||= [3000, 4000, 5000, 7000, 8000, 9000].sample
    end
  end
end
