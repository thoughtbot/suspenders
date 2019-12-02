require_relative "base"

module Suspenders
  class StaticGenerator < Generators::Base
    def add_high_voltage
      gem "high_voltage"
      Bundler.with_clean_env { run "bundle install" }
    end

    def make_placeholder_directory
      empty_directory_with_keep_file "app/views/pages"
    end
  end
end
