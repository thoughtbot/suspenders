require "rails/generators"

module Suspenders
  module Production
    class DeploymentGenerator < Rails::Generators::Base
      source_root File.expand_path(
        File.join("..", "..", "..", "..", "templates"),
        File.dirname(__FILE__),
      )

      def copy_script
        copy_file "bin_deploy", "bin/deploy"
        chmod "bin/deploy", 0o755
      end

      def inform_user
        instructions = <<~MARKDOWN

          ## Deploying

          If you have previously run the `./bin/setup` script,
          you can deploy to staging and production with:

              % ./bin/deploy staging
              % ./bin/deploy production
        MARKDOWN

        append_file "README.md", instructions
      end
    end
  end
end
