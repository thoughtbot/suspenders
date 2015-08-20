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
      template "setup.rb", "setup.rb"
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

    def configure_production_log_level
      replace_in_file(
        'config/environments/production.rb',
        "  # Use the lowest log level to ensure availability of diagnostic information\n  # when problems arise.",
        ''
      )

      replace_in_file(
        'config/environments/production.rb',
        '  config.log_level = :debug',
        '  config.log_level = :info'
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

    def version_gems_in_gemfile
      gemfile = File.read('Gemfile')

      require 'bundler'
      locks = Bundler.locked_gems
      specs = locks.specs

      # Naively convert to single quotes
      gemfile.gsub! '"', "'"

      specs.each do |gem|
        name, version = gem.name, gem.version

        # Don't try to set version if:
        # * source is git or github
        # * version is already set
        gemfile.gsub! /^(?!.*, (git:|github:|'))( *gem '#{name}')/, "\\2, '~> #{version}'"
      end

      File.open 'Gemfile', 'w+' do |file|
        file.puts gemfile
      end
    end

    def set_ruby_to_version_being_used
      create_file '.ruby-version', "#{Suspenders::RUBY_VERSION}\n"
    end

    def setup_heroku_specific_gems
      inject_into_file(
        "Gemfile",
        %{\n\s\sgem "rails_12factor"},
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
        "config.active_job.queue_adapter = :sidekiq"
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

    def configure_unicorn
      copy_file 'unicorn.rb', 'config/unicorn.rb'
    end

    def setup_foreman
      copy_file 'Procfile', 'Procfile'
    end

    def setup_stylesheets
      remove_file "app/assets/stylesheets/application.css"
      copy_file "application.scss",
                "app/assets/stylesheets/application.scss"
    end

    def setup_javascripts
      remove_file "app/assets/javascripts/application.js"
      copy_file "application.js", "app/assets/javascripts/application.js"
      create_empty_directory('app/assets/javascripts/application')
    end

    def install_bourbon_n_friends
      inject_into_file(
        'Gemfile',
        %{\ngem 'bourbon'\ngem 'neat'},
        after: Regexp.new("gem 'rails', '#{Suspenders::RAILS_VERSION}'")
      )
      bundle_command 'install'

      inject_into_file(
        'app/assets/stylesheets/application.scss',
%{
@import "bourbon";
@import "neat";
@import "base/grid-settings";
@import "base/base";
},
        after: /@charset "utf-8";/
      )
    end

    def install_bootstrap
      inject_into_file(
        'Gemfile',
        %{\ngem 'bootstrap-sass'},
        after: /gem 'sass-rails',.*$/
      )
      bundle_command 'install'

      inject_into_file(
        'app/assets/stylesheets/application.scss',
        %{\n@import "bootstrap-sprockets";\n@import "bootstrap";},
        after: /@charset "utf-8";/
      )

      inject_into_file(
        'app/assets/javascripts/application.js',
        %{\n\/\/= require bootstrap-sprockets},
        after: /\/\/= require jquery-ujs/
      )
    end

    def install_foundation
      inject_into_file(
        'Gemfile',
        %{\ngem 'foundation-rails'},
        after: /gem 'sass-rails',.*$/
      )

      inject_into_file(
        'app/assets/stylesheets/application.scss',
        %{\n@import "foundation_and_overrides";},
        after: /@charset "utf-8";/
      )

      inject_into_file(
        'app/assets/javascripts/application.js',
        %{\n\/\/= require foundation},
        after: /\/\/= require jquery-ujs/
      )

      inject_into_file(
        'app/assets/javascripts/application.js',
        %{\n$(document).foundation();},
        after: /\/\/= require_tree ./
      )

      inject_into_file(
        'app/views/layouts/application.html.erb',
        %{<%= javascript_include_tag "vendor/modernizr" %>\n},
        before: /<title>.*$/
      )

      bundle_command 'install'

      result = run('bundle show foundation-rails', capture: true ).gsub("\n",'')
      settings_file = File.join(
        result,
        'vendor', 'assets', 'stylesheets', 'foundation', '_settings.scss'
      )

      create_file(
        "app/assets/stylesheets/foundation_and_overrides.scss",
        File.read(settings_file)
      )
    end

    def gitignore_files
      remove_file '.gitignore'
      copy_file 'suspenders_gitignore', '.gitignore'
      [
        'app/workers',
        'spec/lib',
        'spec/controllers',
        'spec/helpers',
        'spec/support/matchers',
        'spec/support/mixins',
        'spec/support/shared_examples'
      ].each do |dir|
        create_empty_directory(dir)
      end
    end

    def init_git
      run 'git init'
    end

    def setup_deployment_environment_branches
      run 'git branch staging'
      run 'git branch production'
    end

    def create_initial_commit
      run 'git add -A'
      run 'git commit -m "Initial app setup."'
    end

    def setup_and_push_to_origin_remote(remote_url)
      run "git remote add origin #{remote_url}"
      run 'git push --all origin'
    end

    def create_staging_heroku_app(flags)
      rack_env = "RACK_ENV=staging RAILS_ENV=staging"
      app_name = heroku_app_name_for("staging")

      run_heroku "create #{app_name} --ssh-git #{flags}", "staging"
      run_heroku "config:add #{rack_env}", "staging"
      configure_heroku_app("staging")
    end

    def create_production_heroku_app(flags)
      app_name = heroku_app_name_for("production")

      run_heroku "create #{app_name} --ssh-git #{flags}", "production"
      configure_heroku_app("production")
    end

    def create_heroku_apps(flags)
      create_staging_heroku_app(flags)
      create_production_heroku_app(flags)
    end

    def configure_heroku_app(environment)
      run_heroku "addons:create mandrill", environment
      run_heroku "addons:create airbrake:free_heroku", environment
      run_heroku "addons:create papertrail", environment

      domain = "#{heroku_app_name_for(environment)}.herokuapp.com"

      env_vars = [
        'SMTP_DOMAIN=heroku.com',
        'SMTP_ADDRESS=smtp.mandrillapp.com',
        'SMTP_PROVIDER=mandrill',
        "HOST=#{domain}",
        "ASSET_HOST=#{domain}"
      ]

      run_heroku "config:add #{env_vars.join(' ')}", environment
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

    def create_github_repo(repo_name)
      path_addition = override_path_for_tests
      run "#{path_addition} hub create #{repo_name} -p"
    end

    def setup_segment
      copy_file '_analytics.html.erb',
        'app/views/application/_analytics.html.erb'
    end

    def setup_bundler_audit
      copy_file "bundler_audit.rake", "lib/tasks/bundler_audit.rake"
    end

    def setup_spring
      bundle_command "exec spring binstub --all"
    end

    def copy_miscellaneous_files
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

if defined?(RSpec) && defined?(RuboCop)
  require 'rubocop/rake_task'
  require 'rspec/core/rake_task'

  RuboCop::RakeTask.new

  task default: [:spec, :rubocop]
end
        EOS
      end
    end

    def configure_rubocop
      template '.rubocop.yml', '.rubocop.yml'
    end

    def configure_airbrake
      template 'airbrake.rb', 'config/initializers/airbrake.rb'
    end

    def run_stairs
      bundle_command 'install'
      bundle_command 'exec stairs --use-defaults'
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

    def create_empty_directory(name)
      run "mkdir #{name}"
      run "touch #{name}/.keep"
    end
  end
end
