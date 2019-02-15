require_relative "base"

module Suspenders
  class ErrorTrackerGenerator < Generators::Base
    def add_honeybadger
      gem "honeybadger"
      Bundler.with_clean_env { run "bundle install" }
    end
  end
end
