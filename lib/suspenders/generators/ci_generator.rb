require "rails/generators"

module Suspenders
  class CiGenerator < Rails::Generators::Base
    source_root File.expand_path(
      File.join("..", "..", "..", "templates"),
      File.dirname(__FILE__))

    def simplecov_test_integration
      inject_into_file "spec/spec_helper.rb", before: 'SimpleCov.start "rails"' do
        <<-RUBY

  if ENV["CIRCLE_ARTIFACTS"]
    dir = File.join(ENV["CIRCLE_ARTIFACTS"], "coverage")
    SimpleCov.coverage_dir(dir)
  end

        RUBY
      end
    end

    def configure_ci
      template "circle.yml.erb", "circle.yml"
    end
  end
end
