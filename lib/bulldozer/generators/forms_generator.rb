require_relative "base"

module Bulldozer
  class FormsGenerator < Generators::Base
    def add_simple_form
      gem "simple_form"
      Bundler.with_clean_env { run "bundle install" }
    end

    def configure_simple_form
      create_file "config/initializers/simple_form.rb" do
        "SimpleForm.setup {|config|}"
      end

      generate "simple_form:install", "--force"
    end
  end
end
