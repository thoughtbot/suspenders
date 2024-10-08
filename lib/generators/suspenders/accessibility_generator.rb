module Suspenders
  module Generators
    class AccessibilityGenerator < Rails::Generators::Base
      include Suspenders::Generators::APIAppUnsupported

      desc <<~MARKDOWN
        Uses [capybara_accessibility_audit][] and
        [capybara_accessible_selectors][] to encourage and enforce accessibility best
        practices.

        [capybara_accessibility_audit]: https://github.com/thoughtbot/capybara_accessibility_audit
        [capybara_accessible_selectors]: https://github.com/citizensadvice/capybara_accessible_selectors
      MARKDOWN

      def add_capybara_gems
        gem_group :test do
          gem "capybara_accessibility_audit", github: "thoughtbot/capybara_accessibility_audit"
          gem "capybara_accessible_selectors", github: "citizensadvice/capybara_accessible_selectors", tag: "v0.12.0"
        end
        Bundler.with_unbundled_env { run "bundle install" }
      end
    end
  end
end
