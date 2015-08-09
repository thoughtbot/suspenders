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

    def set_test_delivery_method
      inject_into_file(
        "config/environments/development.rb",
        "\n  config.action_mailer.delivery_method = :test",
        after: "config.action_mailer.raise_delivery_errors = true",
      )
    end

    def raise_on_unpermitted_parameters
      config = <<-RUBY
    config.action_controller.action_on_unpermitted_parameters = :raise
      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    def provide_setup_script
      template "bin_setup.erb", "bin/setup", port_number: port, force: true
      run "chmod a+x bin/setup"
    end

    def provide_dev_prime_task
      copy_file 'dev.rake', 'lib/tasks/dev.rake'
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

    def set_up_hound
      copy_file "hound.yml", ".hound.yml"
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
        after: "config.action_mailer.raise_delivery_errors = false"
    end

    def enable_rack_canonical_host
      config = <<-RUBY

  # Ensure requests are only served from one, canonical host name
  config.middleware.use Rack::CanonicalHost, ENV.fetch("HOST")
      RUBY

      inject_into_file(
        "config/environments/production.rb",
        config,
        after: serve_static_files_line
      )
    end

    def enable_rack_deflater
      config = <<-RUBY

  # Enable deflate / gzip compression of controller-generated responses
  config.middleware.use Rack::Deflater
      RUBY

      inject_into_file(
        "config/environments/production.rb",
        config,
        after: serve_static_files_line
      )
    end

    def setup_asset_host
      replace_in_file 'config/environments/production.rb',
        "# config.action_controller.asset_host = 'http://assets.example.com'",
        'config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("HOST"))'

      replace_in_file 'config/initializers/assets.rb',
        "config.assets.version = '1.0'",
        'config.assets.version = (ENV["ASSETS_VERSION"] || "1.0")'

      inject_into_file(
        "config/environments/production.rb",
        '  config.static_cache_control = "public, max-age=#{1.year.to_i}"',
        after: serve_static_files_line
      )
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

    def disallow_wrapping_parameters
      remove_file "config/initializers/wrap_parameters.rb"
    end

    def create_partials_directory
      empty_directory 'app/views/application'
    end

    def create_shared_flashes
      copy_file "_flashes.html.erb", "app/views/application/_flashes.html.erb"
      copy_file "flashes_helper.rb", "app/helpers/flashes_helper.rb"
    end

    def create_shared_javascripts
      copy_file '_javascript.html.erb', 'app/views/application/_javascript.html.erb'
    end

    def create_application_layout
      template 'suspenders_layout.html.erb.erb',
        'app/views/layouts/application.html.erb',
        force: true
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
      inject_into_file(
        "Gemfile",
        %{\n\s\sgem "rails_stdout_logging"},
        after: /group :staging, :production do/
      )
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

    def configure_ci
      template "circle.yml.erb", "circle.yml"
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
      run 'rails g delayed_job:active_record'
    end

    def configure_action_mailer_in_specs
      copy_file 'action_mailer.rb', 'spec/support/action_mailer.rb'
    end

    def configure_time_formats
      remove_file "config/locales/en.yml"
      template "config_locales_en.yml.erb", "config/locales/en.yml"
    end

    def configure_rack_timeout
      rack_timeout_config = <<-RUBY
Rack::Timeout.timeout = (ENV["RACK_TIMEOUT"] || 10).to_i
      RUBY

      append_file "config/environments/production.rb", rack_timeout_config
    end

    def configure_simple_form
      bundle_command "exec rails generate simple_form:install"
    end

    def configure_action_mailer
      action_mailer_host "development", %{"localhost:#{port}"}
      action_mailer_host "test", %{"www.example.com"}
      action_mailer_host "staging", %{ENV.fetch("HOST")}
      action_mailer_host "production", %{ENV.fetch("HOST")}
    end

    def configure_active_job
      configure_application_file(
        "config.active_job.queue_adapter = :delayed_job"
      )
      configure_environment "test", "config.active_job.queue_adapter = :inline"
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

    def configure_puma
      copy_file "puma.rb", "config/puma.rb"
    end

    def setup_foreman
      copy_file 'sample.env', '.sample.env'
      copy_file 'Procfile', 'Procfile'
    end

    def setup_stylesheets
      remove_file "app/assets/stylesheets/application.css"
      copy_file "application.scss",
                "app/assets/stylesheets/application.scss"
    end

    def install_refills
      run "rails generate refills:import flashes"
      run "rm app/views/refills/_flashes.html.erb"
      run "rmdir app/views/refills"
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

    def create_staging_heroku_app(flags)
      rack_env = "RACK_ENV=staging RAILS_ENV=staging"
      app_name = heroku_app_name_for("staging")

      run_heroku "create #{app_name} #{flags}", "staging"
      run_heroku "config:add #{rack_env}", "staging"
    end

    def create_production_heroku_app(flags)
      app_name = heroku_app_name_for("production")

      run_heroku "create #{app_name} #{flags}", "production"
    end

    def create_heroku_apps(flags)
      create_staging_heroku_app(flags)
      create_production_heroku_app(flags)
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
      heroku_app_name = heroku_app_name_for(environment)
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

    def set_heroku_serve_static_files
      %w(staging production).each do |environment|
        run_heroku "config:add RAILS_SERVE_STATIC_FILES=true", environment
      end
    end

    def provide_deploy_script
      copy_file "bin_deploy", "bin/deploy"

      instructions = <<-MARKDOWN

## Deploying

If you have previously run the `./bin/setup` script,
you can deploy to staging and production with:

    $ ./bin/deploy staging
    $ ./bin/deploy production
      MARKDOWN

      append_file "README.md", instructions
      run "chmod a+x bin/deploy"
    end

    def create_github_repo(repo_name)
      path_addition = override_path_for_tests
      run "#{path_addition} hub create #{repo_name}"
    end

    def setup_segment
      copy_file '_analytics.html.erb',
        'app/views/application/_analytics.html.erb'
    end

    def setup_bundler_audit
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
      append_file "Rakefile", %{\ntask default: "bundler:audit"\n}
    end

    def setup_spring
      bundle_command "exec spring binstub --all"
    end

    def copy_miscellaneous_files
      copy_file "browserslist", "browserslist"
      copy_file "errors.rb", "config/initializers/errors.rb"
      copy_file "json_encoding.rb", "config/initializers/json_encoding.rb"
    end

    def customize_error_pages
      meta_tags =<<-EOS
  <meta charset="utf-8" />
  <meta name="ROBOTS" content="NOODP" />
  <meta name="viewport" content="initial-scale=1" />
      EOS

      %w(500 404 422).each do |page|
        inject_into_file "public/#{page}.html", meta_tags, after: "<head>\n"
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

    def generate_secret
      SecureRandom.hex(64)
    end

    def port
      @port ||= [3000, 4000, 5000, 7000, 8000, 9000].sample
    end

    def serve_static_files_line
      "config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?\n"
    end

    def heroku_app_name_for(environment)
      "#{app_name.dasherize}-#{environment}"
    end
  end
end
