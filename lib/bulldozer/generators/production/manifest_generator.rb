require_relative "../base"

module Bulldozer
  module Production
    class ManifestGenerator < Generators::Base
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
    end
  end
end
