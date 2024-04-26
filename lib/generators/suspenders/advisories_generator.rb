module Suspenders
  module Generators
    class AdvisoriesGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates/advisories", __FILE__)
      desc <<~MARKDOWN
        Uses [bundler-audit][] to update the local security database and show
        any relevant issues with the app's dependencies via a Rake task.

        [bundler-audit]: https://github.com/rubysec/bundler-audit
      MARKDOWN

      def add_bundler_audit
        gem_group :development, :test do
          gem "bundler-audit", ">= 0.7.0", require: false
        end
        Bundler.with_unbundled_env { run "bundle install" }
      end

      def modify_rakefile
        content = <<~RUBY

          if Rails.env.local?
            require "bundler/audit/task"
            Bundler::Audit::Task.new
          end
        RUBY

        insert_into_file "Rakefile", content, after: /require_relative "config\/application"\n/
      end
    end
  end
end
