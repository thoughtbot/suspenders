module Suspenders
  module Adapters
    class Heroku
      def initialize(app_builder)
        @app_builder = app_builder
      end

      def set_heroku_remotes
        remotes = <<~SHELL
          #{command_to_join_heroku_app("staging")}
          #{command_to_join_heroku_app("production")}

          git config heroku.remote staging
        SHELL

        app_builder.append_file "bin/setup", remotes
      end

      def create_staging_heroku_app(flags)
        app_name = heroku_app_name_for("staging")

        run_toolbelt_command "create #{app_name} #{flags}", "staging"
      end

      def create_production_heroku_app(flags)
        app_name = heroku_app_name_for("production")

        run_toolbelt_command "create #{app_name} #{flags}", "production"
      end

      def set_heroku_rails_secrets
        %w[staging production].each do |environment|
          run_toolbelt_command(
            "config:add SECRET_KEY_BASE=#{generate_secret}",
            environment
          )
        end
      end

      def set_heroku_honeybadger_env
        %w[staging production].each do |environment|
          run_toolbelt_command(
            "config:add HONEYBADGER_ENV=#{environment}",
            environment
          )
        end
      end

      def set_heroku_backup_schedule
        %w[staging production].each do |environment|
          run_toolbelt_command(
            "pg:backups:schedule DATABASE_URL --at '10:00 UTC'",
            environment
          )
        end
      end

      def create_heroku_pipeline
        pipelines_plugin = `heroku help | grep pipelines`
        if pipelines_plugin.empty?
          puts "You need heroku pipelines plugin. Run: brew upgrade heroku-toolbelt"
          exit 1
        end

        run_toolbelt_command(
          "pipelines:create #{heroku_app_name} \
            -a #{heroku_app_name}-staging --stage staging",
          "staging"
        )

        run_toolbelt_command(
          "pipelines:add #{heroku_app_name} \
            -a #{heroku_app_name}-production --stage production",
          "production"
        )
      end

      def set_heroku_application_host
        %w[staging production].each do |environment|
          run_toolbelt_command(
            "config:add APPLICATION_HOST=#{heroku_app_name}-#{environment}.herokuapp.com",
            environment
          )
        end
      end

      def set_heroku_buildpacks
        %w[staging production].each do |environment|
          run_toolbelt_command(
            "buildpacks:add --index 1 heroku/nodejs",
            environment
          )
          run_toolbelt_command(
            "buildpacks:add --index 2 heroku/ruby",
            environment
          )
        end
      end

      private

      attr_reader :app_builder

      def command_to_join_heroku_app(environment)
        heroku_app_name = heroku_app_name_for(environment)
        <<~SHELL

          if heroku apps:info --app #{heroku_app_name} > /dev/null 2>&1; then
            git remote add #{environment} git@heroku.com:#{heroku_app_name}.git || true
            printf 'You are a collaborator on the "#{heroku_app_name}" Heroku app\n'
          else
            printf 'Ask for access to the "#{heroku_app_name}" Heroku app\n'
          fi
        SHELL
      end

      def heroku_app_name
        app_builder.app_name.dasherize
      end

      def heroku_app_name_for(environment)
        "#{heroku_app_name}-#{environment}"
      end

      def generate_secret
        SecureRandom.hex(64)
      end

      def run_toolbelt_command(command, environment)
        app_builder.run(
          "heroku #{command} --remote #{environment}"
        )
      end
    end
  end
end
