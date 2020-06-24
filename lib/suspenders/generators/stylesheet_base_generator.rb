require_relative "base"

module Suspenders
  class StylesheetBaseGenerator < Generators::Base
    def add_stylesheet_gems
      gem "bourbon", ">= 6.0.0"
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def remove_prior_config
      remove_file "app/assets/stylesheets/application.css"
    end

    def add_css_config
      copy_file(
        "application.scss",
        "app/assets/stylesheets/application.scss",
        force: true,
      )
    end

    def install_bitters
      run "bitters install --path app/assets/stylesheets"
    end

    def install_normalize_css
      run "bin/yarn add normalize.css"
    end
  end
end
