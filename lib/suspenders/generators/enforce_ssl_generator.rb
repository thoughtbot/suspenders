require "rails/generators"
require_relative "../actions"

module Suspenders
  class EnforceSslGenerator < Rails::Generators::Base
    include Suspenders::Actions

    def enforce_ssl
      configure_environment "production", "config.force_ssl = true"
    end
  end
end
