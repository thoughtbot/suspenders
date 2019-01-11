require_relative "base"

module Suspenders
  class JsonGenerator < Generators::Base
    def add_oj
      gem "oj"
      Bundler.with_clean_env { run "bundle install" }
    end
  end
end
