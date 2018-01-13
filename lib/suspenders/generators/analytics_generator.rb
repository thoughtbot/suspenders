require "rails/generators"

module Suspenders
  class AnalyticsGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__),
    )

    def install_partial
      copy_file "_analytics.html.erb",
        "app/views/application/_analytics.html.erb"
    end

    def render_partial
      if File.exist?(js_partial)
        inject_into_file js_partial,
          %{\n\n<%= render "analytics" %>},
          after: "<%= yield :javascript %>"
      end
    end

    private

    def js_partial
      "app/views/application/_javascript.html.erb"
    end
  end
end
