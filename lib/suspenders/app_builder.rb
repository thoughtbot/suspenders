require "forwardable"

module Suspenders
  class AppBuilder < Rails::AppBuilder
    include Suspenders::Actions
    extend Forwardable

    def_delegators :heroku_adapter,
                   :create_heroku_pipelines_config_file,
                   :create_heroku_pipeline,
                   :create_production_heroku_app,
                   :create_staging_heroku_app,
                   :provide_review_apps_setup_script,
                   :set_heroku_rails_secrets,
                   :set_heroku_remotes,
                   :set_heroku_serve_static_files,
                   :set_up_heroku_specific_gems

    def readme
      template 'README.md.erb', 'README.md'
    end

    def raise_on_missing_assets_in_test
      inject_into_file(
        "config/environments/test.rb",
        "\n  config.assets.raise_runtime_errors = true",
        after: "Rails.application.configure do",
      )
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

    def add_bullet_gem_configuration
      config = <<-RUBY
  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    Bullet.rails_logger = true
  end

      RUBY

      inject_into_file(
        "config/environments/development.rb",
        config,
        after: "config.action_mailer.raise_delivery_errors = true\n",
      )
    end

    def raise_on_unpermitted_parameters
      config = <<-RUBY
    config.action_controller.action_on_unpermitted_parameters = :raise
      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    def configure_quiet_assets
      config = <<-RUBY
    config.quiet_assets = true
      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    def provide_setup_script
      template "bin_setup", "bin/setup", force: true
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

    def generate_factories_file
      copy_file "factories.rb", "spec/factories.rb"
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

  if ENV.fetch("HEROKU_APP_NAME", "").include?("staging-pr-")
    ENV["APPLICATION_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
  end

  # Ensure requests are only served from one, canonical host name
  config.middleware.use Rack::CanonicalHost, ENV.fetch("APPLICATION_HOST")
      RUBY

      inject_into_file(
        "config/environments/production.rb",
        config,
        after: "Rails.application.configure do",
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
        'config.action_controller.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))'

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

    def enable_database_cleaner
      copy_file 'database_cleaner_rspec.rb', 'spec/support/database_cleaner.rb'
    end

    def provide_shoulda_matchers_config
      copy_file(
        "shoulda_matchers_config_rspec.rb",
        "spec/support/shoulda_matchers.rb"
      )
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

    def configure_background_jobs_for_rspec
      run 'rails g delayed_job:active_record'
    end

    def configure_action_mailer_in_specs
      copy_file 'action_mailer.rb', 'spec/support/action_mailer.rb'
    end

    def configure_capybara_webkit
      copy_file "capybara_webkit.rb", "spec/support/capybara_webkit.rb"
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
      action_mailer_host "development", %{"localhost:3000"}
      action_mailer_host "test", %{"www.example.com"}
      action_mailer_host "production", %{ENV.fetch("APPLICATION_HOST")}
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

    def set_up_forego
      copy_file "Procfile", "Procfile"
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

    def copy_dotfiles
      directory("dotfiles", ".")
    end

    def init_git
      run 'git init'
    end

    def git_init_commit
      if @@user_choice.present? && @@user_choice.include?(:gitcommit)
        run 'git add .'
        run 'git commit -m "Init commit"'
      end
    end

  def create_heroku_apps(flags)
      create_staging_heroku_app(flags)
      create_production_heroku_app(flags)
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

    def configure_automatic_deployment
      deploy_command = <<-YML.strip_heredoc
      deployment:
        staging:
          branch: master
          commands:
            - bin/deploy staging
      YML

      append_file "circle.yml", deploy_command
    end

    def create_github_repo(repo_name)
      run "hub create #{repo_name}"
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

    def remove_config_comment_lines
      config_files = [
        "application.rb",
        "environment.rb",
        "environments/development.rb",
        "environments/production.rb",
        "environments/test.rb",
      ]

      config_files.each do |config_file|
        path = File.join(destination_root, "config/#{config_file}")

        accepted_content = File.readlines(path).reject do |line|
          line =~ /^.*#.*$/ || line =~ /^$\n/
        end

        File.open(path, "w") do |file|
          accepted_content.each { |line| file.puts line }
        end
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

    def users_gems
      @@user_choice = []
      choose_template_engine
      rails_db_gem
      faker_gem
      meta_request_gem
      rubocop_gem
      guard_gem
      # Placeholder for other gem additions

      users_init_commit_choice
      add_user_gems
    end

    def choose_template_engine
      variants = { none: 'Erb', slim: 'Slim', haml: 'Haml' }
      @@user_choice.push choice 'Select template engine: ', variants
    end

    def meta_request_gem
      gem_name = __callee__.to_s.gsub(/_gem/, '')
      gem_description = <<-TEXT
    Rails meta panel in chrome console. Very usefull in AJAX debugging. 
    Save link for chrome add-on.
    https://chrome.google.com/webstore/detail/railspanel/gjpfobpafnhjhbajcjgccbbdofdckggg
      TEXT
      @@user_choice.push yes_no_question gem_name, gem_description
    end

    def rails_db_gem
      gem_name = __callee__.to_s.gsub(/_gem/, '')
      gem_description = 'Add gem for pretty view in browser & xls export for models?'
      @@user_choice.push yes_no_question gem_name, gem_description
    end

    def faker_gem
      gem_name = __callee__.to_s.gsub(/_gem/, '')
      gem_description = 'Add gem for generate fake data in testing?'
      @@user_choice.push yes_no_question gem_name, gem_description
    end

    def rubocop_gem
      gem_name = __callee__.to_s.gsub(/_gem/, '')
      gem_description = 'Add code inspector and code formatting tool?'
      @@user_choice.push yes_no_question gem_name, gem_description
    end

    def guard_gem
      gem_name = __callee__.to_s.gsub(/_gem/, '')
      gem_description = 'Add guard (with livereliad) and dependences?'
      @@user_choice.push yes_no_question gem_name, gem_description
    end
    
    def users_init_commit_choice
      variants = { none: 'No', gitcommit: 'Make init commit at the end?' }
      @@user_choice.push choice 'Commit? ', variants
    end

    def add_haml_gem
      inject_into_file('Gemfile', "\ngem 'haml-rails'", after: '# user_choice')
    end

    def add_slim_gem
      inject_into_file('Gemfile', "\ngem 'slim-rails'", after: '# user_choice')
    end

    def add_rails_db_gem
      inject_into_file('Gemfile', "\n  gem 'rails_db'\n  gem 'axlsx_rails'", after: 'group :development do')
    end
 
    def add_rubocop_gem
      inject_into_file('Gemfile', "\n  gem 'rubocop', require: false", after: 'group :development do')
    end

    def add_guard_gem
      t=<<-TEXT.chomp

  gem 'guard'
  gem 'guard-livereload', '~> 2.4', require: false
      TEXT
      inject_into_file('Gemfile', t, after: 'group :development do')
    end

    def add_guard_rubocop_gem
      inject_into_file('Gemfile', "\n  gem 'guard-rubocop'", after: 'group :development do')
    end

    def add_meta_request_gem
      inject_into_file('Gemfile', "\n  gem 'meta_request'", after: 'group :development do')
    end

    def add_faker_gem
      inject_into_file('Gemfile', "\n  gem 'faker'", after: 'group :test do')
    end

    def add_user_gems
      add_haml_gem           if @@user_choice.include? :haml
      add_slim_gem           if @@user_choice.include? :slim   
      add_rails_db_gem       if @@user_choice.include? :rails_db  
      add_faker_gem          if @@user_choice.include? :faker 
      add_meta_request_gem   if @@user_choice.include? :meta_request 
      add_rubocop_gem        if @@user_choice.include? :rubocop 
      add_guard_gem          if @@user_choice.include? :guard 
      add_guard_rubocop_gem  if @@user_choice.include?(:guard) && @@user_choice.include?(:rubocop) 
    end

    def post_init
      run 'guard init' if @@user_choice.present? && @@user_choice.include?(:guard)
      if @@user_choice.include? :rubocop
        t=<<-TEXT
require 'rubocop/rake_task'
RuboCop::RakeTask.new
        TEXT
        append_file 'Rakefile', t  
      end
    end

    private

    def yes_no_question(gem_name, gem_description)
      gem_name_color = "\033[33m#{gem_name.capitalize}.\033[0m "
      variants = { none: 'No', gem_name.to_sym => gem_name_color + gem_description }
      choice "Use #{gem_name}? ", variants
    end

    def choice(selector, variants)
      values = []
      say "\n  \033[1m\033[36m#{selector}\033[0m"
      variants.each_with_index do |wariant, i|
        values.push wariant[0]
        say "#{i.to_s.rjust(10)}. #{wariant[1]}"
      end
      answer = ask "\033[1m\033[36m  Enter choice: \033[0m".rjust(10) until (0...variants.length)
                                                                            .to_a.map(&:to_s).include? answer
      values[answer.to_i]
    end

    def raise_on_missing_translations_in(environment)
      config = 'config.action_view.raise_on_missing_translations = true'

      uncomment_lines("config/environments/#{environment}.rb", config)
    end

    def heroku_adapter
      @heroku_adapter ||= Adapters::Heroku.new(self)
    end

    def serve_static_files_line
      "config.serve_static_files = ENV['RAILS_SERVE_STATIC_FILES'].present?\n"
    end
  end
end
