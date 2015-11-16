module Suspenders
  module Adapters
    class Heroku
      def initialize(app_builder)
        @app_builder = app_builder
      end

      def set_heroku_remotes
        remotes = <<-SHELL.strip_heredoc

          # Set up the staging and production apps.
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

      def set_heroku_rails_secrets
        %w(staging production).each do |environment|
          run_toolbelt_command(
            "config:add SECRET_KEY_BASE=#{generate_secret}",
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
