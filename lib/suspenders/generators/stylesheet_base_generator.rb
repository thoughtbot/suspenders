require "rails/generators"

module Suspenders
  class StylesheetBaseGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__))

    def add_stylesheet_gems
      gem "bourbon", "5.0.0.beta.6"
      gem "neat", "~> 1.7.0"
      gem "refills", group: [:development, :test]
    end

    def add_css_config
      copy_file(
        "application.scss",
        "app/assets/stylesheets/application.scss",
        force: true,
      )
    end

    def remove_prior_config
      remove_file "app/assets/stylesheets/application.css"
    end
  end
end
