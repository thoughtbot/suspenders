module Suspenders
  module Generators
    class RakeGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/rake", __FILE__)
      desc <<~MARKDOWN
        Adds default Raketask wich is a wrapper for `suspenders:rake`.

        This will do the following:

          - Run the test suite.
          - Run a Ruby and ERB linter.
          - Scan the Ruby codebase for any dependency vulnerabilities.
      MARKDOWN

      def configure_default_rake_task
        append_to_file "Rakefile", <<~RUBY

          if Rails.env.local?
            task default: "suspenders:rake"
          end
        RUBY
      end
    end
  end
end
