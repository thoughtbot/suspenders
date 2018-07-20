require "rails/generators"

module Suspenders
  class JsonGenerator < Rails::Generators::Base
    def add_oj
      gem "oj"
      Bundler.with_clean_env { run "bundle install" }
    end
  end
end
