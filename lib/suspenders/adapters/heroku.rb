module Suspenders
  module Adapters
    class Heroku
      def initialize(app_builder)
        @app_builder = app_builder
      end

      def set_heroku_remotes
        remotes = <<-SHELL.strip_heredoc
          #{command_to_join_heroku_app('staging')}
          #{command_to_join_heroku_app('production')}

          git config heroku.remote staging
        SHELL

        app_builder.append_file "bin/setup", remotes
      end

      def set_up_heroku_specific_gems
        app_builder.inject_into_file(
          "Gemfile",
          %{\n\s\sgem "rails_stdout_logging"},
          after: /group :staging, :production do/,
        )
      end

      def create_staging_heroku_app(flags)
        rack_env = "RACK_ENV=staging"
        app_name = heroku_app_name_for("staging")

        run_toolbelt_command "create #{app_name} #{flags}", "staging"
        run_toolbelt_command "config:add #{rack_env}", "staging"
      end

      def create_production_heroku_app(flags)
        app_name = heroku_app_name_for("production")

        run_toolbelt_command "create #{app_name} #{flags}", "production"
      end

      def set_heroku_rails_secrets
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add SECRET_KEY_BASE=#{generate_secret}",
            environment,
          )
        end
      end

      def provide_review_apps_setup_script
        app_builder.template(
          "bin_setup_review_app.erb",
          "bin/setup_review_app",
          force: true,
        )
        app_builder.run "chmod a+x bin/setup_review_app"
      end

      def create_heroku_pipelines_config_file
        app_builder.template "app.json.erb", "app.json"
      end

      def create_heroku_pipeline
        pipelines_plugin = `heroku plugins | grep pipelines`
        if pipelines_plugin.empty?
          puts "You need heroku pipelines plugin. Run: heroku plugins:install heroku-pipelines"
          exit 1
        end

        heroku_app_name = app_builder.app_name.dasherize
        run_toolbelt_command(
          "pipelines:create #{heroku_app_name} \
            -a #{heroku_app_name}-staging --stage staging",
          "staging",
        )

        run_toolbelt_command(
          "pipelines:add #{heroku_app_name} \
            -a #{heroku_app_name}-production --stage production",
          "production",
        )
      end

      def set_heroku_serve_static_files
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add RAILS_SERVE_STATIC_FILES=true",
            environment,
          )
        end
      end

      private

      attr_reader :app_builder

      def command_to_join_heroku_app(environment)
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

      def heroku_app_name_for(environment)
        "#{app_builder.app_name.dasherize}-#{environment}"
      end

      def generate_secret
        SecureRandom.hex(64)
      end

      def run_toolbelt_command(command, environment)
        app_builder.run(
          "heroku #{command} --remote #{environment}",
        )
      end
    end
  end
end
