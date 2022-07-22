require "forwardable"

module Suspenders
  class AppBuilder < Rails::AppBuilder
    include Suspenders::Actions
    extend Forwardable

    def_delegators(
      :heroku_adapter,
      :create_heroku_pipeline,
      :create_production_heroku_app,
      :create_staging_heroku_app,
      :set_heroku_application_host,
      :set_heroku_backup_schedule,
      :set_heroku_honeybadger_env,
      :set_heroku_rails_secrets,
      :set_heroku_remotes,
      :set_heroku_buildpacks
    )

    def readme
      template "README.md.erb", "README.md"
    end

    def gitignore
      copy_file "suspenders_gitignore", ".gitignore"
    end

    def gemfile
      template "Gemfile.erb", "Gemfile"
    end

    def setup_rack_mini_profiler
      copy_file(
        "rack_mini_profiler.rb",
        "config/initializers/rack_mini_profiler.rb"
      )
    end

    def raise_on_missing_assets_in_test
      configure_environment "test", "config.assets.raise_runtime_errors = true"
    end

    def raise_on_delivery_errors
      replace_in_file "config/environments/development.rb",
        "raise_delivery_errors = false", "raise_delivery_errors = true"
    end

    def set_test_delivery_method
      inject_into_file(
        "config/environments/development.rb",
        "\n  config.action_mailer.delivery_method = :file",
        after: "config.action_mailer.raise_delivery_errors = true"
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
    config.assets.quiet = true
      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    def provide_setup_script
      template "bin_setup", "bin/setup", force: true
      run "chmod a+x bin/setup"
    end

    def configure_generators
      config = <<-RUBY

    config.generators do |generate|
      generate.helper false
      generate.javascripts false
      generate.controller_specs false
      generate.request_specs true
      generate.routing_specs false
      generate.stylesheets false
      generate.test_framework :rspec
      generate.view_specs false
    end

      RUBY

      inject_into_class "config/application.rb", "Application", config
    end

    def configure_local_mail
      copy_file "email.rb", "config/initializers/email.rb"
    end

    def setup_asset_host
      replace_in_file "config/environments/production.rb",
        "# config.asset_host = 'http://assets.example.com'",
        'config.asset_host = ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))'

      if File.exist?("config/initializers/assets.rb")
        replace_in_file "config/initializers/assets.rb",
          "config.assets.version = '1.0'",
          'config.assets.version = (ENV["ASSETS_VERSION"] || "1.0")'
      end

      config = <<~EOD
        config.public_file_server.headers = {
            "Cache-Control" => "public, max-age=31557600",
          }
      EOD

      configure_environment("production", config)
    end

    def setup_secret_token
      template "secrets.yml", "config/secrets.yml", force: true
    end

    def disallow_wrapping_parameters
      remove_file "config/initializers/wrap_parameters.rb"
    end

    def use_postgres_config_template
      template "postgresql_database.yml.erb", "config/database.yml",
        force: true
    end

    def create_database
      bundle_command "exec rails db:create db:migrate"
    end

    def run_database_migrations
      bundle_command "exec rails db:migrate"
    end

    def replace_gemfile
      template "Gemfile.erb", "Gemfile", force: true do |content|
        if development_env?
          content.gsub(%r{gem .suspenders.}) { |s| %(#{s}, path: "#{root_path}") }
        else
          content
        end
      end
    end

    def ruby_version
      create_file ".ruby-version", "#{Suspenders::RUBY_VERSION}\n"
    end

    def configure_i18n_for_missing_translations
      raise_on_missing_translations_in("development")
      raise_on_missing_translations_in("test")
    end

    def configure_action_mailer_in_specs
      copy_file "action_mailer.rb", "spec/support/action_mailer.rb"
    end

    def configure_time_formats
      remove_file "config/locales/en.yml"
      template "config_locales_en.yml.erb", "config/locales/en.yml"
    end

    def configure_action_mailer
      action_mailer_host "development", %("localhost:3000")
      action_mailer_asset_host "development", %("http://localhost:3000")
      action_mailer_host "test", %("www.example.com")
      action_mailer_asset_host "test", %("http://www.example.com")
      action_mailer_host "production", %{ENV.fetch("APPLICATION_HOST")}
      # rubocop:disable Lint/InterpolationCheck
      action_mailer_asset_host(
        "production",
        %q{"https://#{ENV.fetch("ASSET_HOST", ENV.fetch("APPLICATION_HOST"))}"}
      )
      # rubocop:enable Lint/InterpolationCheck
    end

    def create_heroku_apps(flags)
      create_staging_heroku_app(flags)
      create_production_heroku_app(flags)
    end

    def configure_automatic_deployment
      append_file "Procfile", "release: bin/auto_migrate\n"
      copy_file "bin_auto_migrate", "bin/auto_migrate"
    end

    def create_github_repo(repo_name)
      run "hub create #{repo_name}"
    end

    def copy_miscellaneous_files
      copy_file "errors.rb", "config/initializers/errors.rb"
      copy_file "json_encoding.rb", "config/initializers/json_encoding.rb"
    end

    def remove_config_comment_lines
      config_files = [
        "application.rb",
        "environment.rb",
        "environments/development.rb",
        "environments/production.rb",
        "environments/test.rb"
      ]

      config_files.each do |config_file|
        path = Pathname(destination_root).join("config", config_file)
        source = Actions::StripCommentsAction.call(path.read)

        path.write(source)
      end
    end

    def remove_routes_comment_lines
      replace_in_file "config/routes.rb",
        /Rails\.application\.routes\.draw do.*end/m,
        "Rails.application.routes.draw do\nend"
    end

    def setup_default_rake_task
      append_file "Rakefile" do
        <<~EOS
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

    def root_path
      @root_path ||= Pathname(__dir__).join("..", "..").expand_path
    end

    def development_env?
      root_path.join("suspenders.gemspec").exist?
    end

    def raise_on_missing_translations_in(environment)
      config = "config.i18n.raise_on_missing_translations = true"

      uncomment_lines("config/environments/#{environment}.rb", config)
    end

    def heroku_adapter
      @heroku_adapter ||= Adapters::Heroku.new(self)
    end
  end
end
