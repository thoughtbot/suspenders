module Suspenders
  module Adapters
    class CircleCI
      def initialize(app_builder)
        @app_builder = app_builder
      end

      def configure_circleci
        app_builder.empty_directory(".circleci")
        app_builder.template "circleci.yml.erb", ".circleci/config.yml"
      end

      def configure_circleci_deployment
        deploy_command = <<-YML.strip_heredoc
        deploy:
          docker:
            - image: buildpack-deps:trusty
          steps:
            - checkout
            - run:
                name: Deploy to staging
                command: bin/deploy staging

      workflows:
        version: 2
        build-deploy:
          jobs:
            - build
            - deploy:
                requires:
                  - build
                filters:
                  branches:
                    only: master

        YML

        app_builder.append_file ".circleci/config.yml", deploy_command
      end

      private

      attr_reader :app_builder
    end
  end
end
