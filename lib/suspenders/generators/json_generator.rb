require_relative "base"

module Suspenders
  class JsonGenerator < Generators::Base
    def add_oj
      gem "oj"
      Bundler.with_unbundled_env { run "bundle install" }
    end

    def configure_oj
      copy_file "oj.rb", "config/initializers/oj.rb"
    end
  end
end
