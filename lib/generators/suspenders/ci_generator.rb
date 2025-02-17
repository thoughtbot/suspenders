module Suspenders
  module Generators
    class CiGenerator < Rails::Generators::Base
      include Suspenders::Generators::DatabaseUnsupported
      include Suspenders::Generators::Helpers

      source_root File.expand_path("../../templates/ci", __FILE__)
      desc <<~MARKDOWN
        Uses [GitHub Actions][] for CI

        [GitHub Actions]: https://docs.github.com/en/actions
      MARKDOWN

      def ci_files
        template "ci.yml", ".github/workflows/ci.yml", force: true
      end

      private

      def scan_ruby?
        has_gem? "bundler-audit"
      end

      def scan_js?
        File.exist?("bin/importmap") && using_node?
      end

      def lint?
        using_node? && has_gem?("standard") && has_yarn_script?("lint")
      end

      def using_node?
        File.exist? "package.json"
      end

      def has_gem?(name)
        Bundler.rubygems.find_name(name).any?
      end

      def using_rspec?
        File.exist? "spec"
      end

      def has_yarn_script?(name)
        return false if !using_node?

        content = File.read("package.json")
        json = JSON.parse(content)

        json.dig("scripts", name)
      end
    end
  end
end
