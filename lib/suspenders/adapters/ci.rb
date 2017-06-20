module Suspenders
  module Adapters
    class Ci
      def initialize(app_builder)
        @app_builder = app_builder
      end

      def configure_ci(provider)
        adapter_for(provider).configure
      end

      def configure_automatic_deployment(provider)
        adapter_for(provider).configure_deployment
      end

      private

      attr_reader :app_builder

      def adapter_for(provider)
        case provider
        when "travis"   then Travis.new(app_builder)
        when "circle"   then Circle.new(app_builder)
        when "codeship" then Codeship.new(app_builder)
        end
      end

      class Base
        def initialize(app_builder)
          @app_builder = app_builder
        end

        def configure
          app_builder.template file_source, file_destination
        end

        def configure_deployment
          app_builder.append_file file_destination, deploy_commands
        end

        private

        attr_reader :app_builder
      end

      class Travis < Base
        def file_source
          "travis.yml.erb"
        end

        def file_destination
          ".travis.yml"
        end

        def deploy_commands
          <<-YML.strip_heredoc
          deploy:
            provider: script
            script: bin/deploy staging
            on:
              branch: staging
          YML
        end
      end

      class Circle < Base
        def file_source
          "circle.yml.erb"
        end

        def file_destination
          "circle.yml"
        end

        def deploy_commands
          <<-YML.strip_heredoc
          deployment:
            staging:
              branch: master
              commands:
                - bin/deploy staging
          YML
        end
      end

      class Codeship < Base
        def file_source
          "codeship-steps.yml.erb"
        end

        def file_destination
          "codeship-steps.yml"
        end

        def configure
          app_builder.template "codeship-services.yml.erb",
            "codeship-services.yml"

          super
        end

        def deploy_commands
          <<-YML.strip_heredoc
            TODO
          YML
        end
      end

      class Invalid < Circle
        def initialize(app_builder)
          puts "--ci option not valid, defaulting to CircleCI"
          super(app_builder)
        end
      end
    end
  end
end
