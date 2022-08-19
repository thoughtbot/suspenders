require_relative "base"

module Suspenders
  class AccessibilityGenerator < Generators::Base
    def capybara_gems
      gem "capybara_accessibility_audit", group: [:test]
      gem "capybara_accessible_selectors", group: [:test],
        github: "citizensadvice/capybara_accessible_selectors"
      Bundler.with_unbundled_env { run "bundle install" }
    end
  end
end
