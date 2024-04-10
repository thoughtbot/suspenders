module Suspenders
  module Generators
    class RakeGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/rake", __FILE__)
      desc <<~MARKDOWN
        Configures the default Rake task to audit and lint the codebase with
        `bundler-audit` and `standard`, in addition to running the test suite.
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
