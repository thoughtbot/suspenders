module Suspenders
  module Generators
    class PrerequisitesGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/prerequisites", __FILE__)

      desc <<~MARKDOWN
        Creates `.node-version` file set to the current LTS version.
      MARKDOWN

      def node_version
        template "node-version", ".node-version"
      end
    end
  end
end
