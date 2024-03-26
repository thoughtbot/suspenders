module Suspenders
  module Generators
    class PrerequisitesGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/prerequisites", __FILE__)

      desc "Configures prerequisites. Currently Node."

      def node_version
        template "node-version", ".node-version"
      end
    end
  end
end
