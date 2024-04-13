module Suspenders
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      include Suspenders::Generators::APIAppUnsupported

      desc <<~MARKDOWN
        Configures flash messages, page titles and the document lang. Disables Turbo's InstantClick.
      MARKDOWN
      source_root File.expand_path("../../templates/views", __FILE__)

      def install_gems
        gem "title"

        Bundler.with_unbundled_env { run "bundle install" }
      end

      def create_views
        copy_file "flashes.html.erb", "app/views/application/_flashes.html.erb"
      end

      def update_application_layout
        insert_into_file "app/views/layouts/application.html.erb", "    <%= render \"flashes\" -%>\n", after: "<body>\n"
        gsub_file "app/views/layouts/application.html.erb", /<html>/, "<html lang=\"<%= I18n.locale %>\">"
        gsub_file "app/views/layouts/application.html.erb", /<title>.*<\/title>/, "<title><%= title %></title>"
        insert_into_file "app/views/layouts/application.html.erb", "    <meta name=\"turbo-prefetch\" content=\"false\">\n", after: "</title>"
      end
    end
  end
end
