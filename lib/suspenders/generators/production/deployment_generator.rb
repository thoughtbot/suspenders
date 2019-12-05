require_relative "../base"

module Suspenders
  module Production
    class DeploymentGenerator < Generators::Base
      def copy_script
        copy_file "bin_deploy", "bin/deploy"
        chmod "bin/deploy", 0o755
      end

      def inform_user
        append_template_to_file "README.md", "partials/deployment_readme.md"
      end
    end
  end
end
