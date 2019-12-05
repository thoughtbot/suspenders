require_relative "base"

module Suspenders
  class CiGenerator < Generators::Base
    def simplecov_gem
      gem "simplecov", require: false, group: [:test]
      Bundler.with_clean_env { run "bundle install" }
    end

    def simplecov_test_integration
      prepend_template_to_file(test_helper_file, "partials/ci_simplecov.rb")
    end

    def configure_ci
      template "circle.yml.erb", "circle.yml"
    end

    private

    def test_helper_file
      if using_rspec?
        "spec/spec_helper.rb"
      else
        "test/test_helper.rb"
      end
    end

    def using_rspec?
      File.exist?("spec/spec_helper.rb")
    end
  end
end
