require "rails/generators"
require_relative "../../actions"

module Suspenders
  module Production
    class ManifestGenerator < Rails::Generators::Base
      include Suspenders::Actions

      def render_manifest
        expand_json(
          "app.json",
          name: app_name.dasherize,
          scripts: {},
          env: {
            APPLICATION_HOST: { required: true },
            EMAIL_RECIPIENTS: { required: true },
            HEROKU_APP_NAME: { required: true },
            HEROKU_PARENT_APP_NAME: { required: true },
            RACK_ENV: { required: true },
            SECRET_KEY_BASE: { generator: "secret" },
          },
          addons: ["heroku-postgresql"],
        )
      end

      private

      def app_name
        Rails.application.class.parent_name.demodulize.underscore.dasherize
      end
    end
  end
end
