require_relative "base"

module Bulldozer
  class DeviseTokenAuthGenerator < Generators::Base
    def copy_config_file
      copy_file "devise.rb", "config/initializers/devise.rb"
      copy_file "devise_token_auth.rb", "config/initializers/devise_token_auth.rb"
    end

    def configure_token_auth
      configure_concern_on_base_controller(
        "include DeviseTokenAuth::Concerns::SetUserByToken",
      )

      configure_default_url_options(
        'config/environments/development.rb',
        "config.action_mailer.default_url_options = { host: ENV.fetch('RAILS_URL') {} }"
      )
      
      configure_default_url_options(
        'config/environments/development.rb',
        "Rails.application.routes.default_url_options[:host] = ENV.fetch('RAILS_URL') {}"
      )

      configure_default_url_options(
        'config/environments/test.rb', 
        "config.action_mailer.default_url_options = { host: ENV.fetch('RAILS_URL') { 'localhost:3000' } }"
      )
      
      configure_default_url_options(
        'config/environments/test.rb', 
        "Rails.application.routes.default_url_options[:host] = ENV.fetch('RAILS_URL') { 'localhost:3000' }"
      )

      configure_default_url_options(
        'config/environments/production.rb', 
        "config.action_mailer.default_url_options = { host: ENV['PRODUCTION_URL'] }"
      )
      
      configure_default_url_options(
        'config/environments/production.rb', 
        "Rails.application.routes.default_url_options[:host] = ENV['PRODUCTION_URL']"
      )
    end

    private

    def configure_concern_on_base_controller(config)
      inject_into_file(
        "app/controllers/application_controller.rb",
        "\n    #{config}",
        after: "\n  class ApplicationController < ActionController::API",
      )
    end
    
    def configure_default_url_options(path, config)
      inject_into_file(
        path, "\n    #{config}", before: "\n  end",
      )
    end
  end
end
