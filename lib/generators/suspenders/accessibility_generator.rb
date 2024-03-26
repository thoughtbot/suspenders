module Suspenders
  module Generators
    class AccessibilityGenerator < Rails::Generators::Base
      include Suspenders::Generators::APIAppUnsupported

      desc "Installs capybara_accessibility_audit and capybara_accessible_selectors"

      def add_capybara_gems
        gem_group :test do
          gem "capybara_accessibility_audit"
          gem "capybara_accessible_selectors", github: "citizensadvice/capybara_accessible_selectors"
        end
        Bundler.with_unbundled_env { run "bundle install" }
      end
    end
  end
end
