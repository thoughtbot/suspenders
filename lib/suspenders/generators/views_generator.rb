require_relative "base"

module Suspenders
  class ViewsGenerator < Generators::Base
    def create_partials_directory
      empty_directory "app/views/application"
    end

    def create_shared_flashes
      copy_file "_flashes.html.erb", "app/views/application/_flashes.html.erb"
      copy_file "flashes_helper.rb", "app/helpers/flashes_helper.rb"
    end

    def create_shared_css_overrides
      copy_file "_css_overrides.html.erb",
        "app/views/application/_css_overrides.html.erb"
    end

    def create_application_layout
      template "suspenders_layout.html.erb.erb",
        "app/views/layouts/application.html.erb",
        force: true
    end
  end
end
