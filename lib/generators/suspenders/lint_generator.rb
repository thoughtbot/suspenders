module Suspenders
  module Generators
    class LintGenerator < Rails::Generators::Base
      desc "Sets up standard"

      def setup_standard
        gem "standard", group: [:development, :test]
        Bundler.with_unbundled_env { run "bundle install" }
        prepend_to_file("Rakefile", 'require "standard/rake"')
      end
    end
  end
end

