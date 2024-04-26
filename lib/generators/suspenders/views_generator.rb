module Suspenders
  module Generators
    class ViewsGenerator < Rails::Generators::Base
      include Suspenders::Generators::APIAppUnsupported

      source_root File.expand_path("../../templates/views", __FILE__)
      desc <<~MARKDOWN
        - A [partial][] for [flash messages][] is located in `app/views/application/_flashes.html.erb`.
        - Sets [lang][] attribute on `<html>` element to `en` via `I18n.local`.
        - Dynamically sets `<title>` via the [title][] gem.
        - Disables Turbo's [Prefetch][] in an effort to reduce unnecessary network requests.

        [partial]: https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials
        [flash messages]: https://guides.rubyonrails.org/action_controller_overview.html#the-flash
        [lang]: https://developer.mozilla.org/en-US/docs/Web/HTML/Global_attributes/lang
        [title]: https://github.com/calebhearth/title
        [Prefetch]: https://turbo.hotwired.dev/handbook/drive#prefetching-links-on-hover
      MARKDOWN

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
