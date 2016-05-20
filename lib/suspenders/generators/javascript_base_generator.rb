require "rails/generators"

module Suspenders
  class JavascriptBaseGenerator < Rails::Generators::Base
    def add_jquery_rails
      gem "jquery-rails"
    end
  end
end
