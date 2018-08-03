require "rails/generators"
require_relative "../../actions"

module Suspenders
  module Staging
    class PullRequestsGenerator < Rails::Generators::Base
      include Suspenders::Actions

      source_root File.expand_path(
        File.join("..", "..", "..", "..", "templates"),
        File.dirname(__FILE__),
      )

      def configure_heroku_staging_pr_pipeline_host
        config = <<-RUBY

  if ENV.fetch("HEROKU_APP_NAME", "").include?("staging-pr-")
    ENV["APPLICATION_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
    ENV["ASSET_HOST"] = ENV["HEROKU_APP_NAME"] + ".herokuapp.com"
  end
        RUBY

        inject_into_file(
          "config/environments/production.rb",
          config,
          after: "Rails.application.configure do\n",
        )
      end

      def create_review_apps_setup_script
        template(
          "bin_setup_review_app.erb",
          "bin/setup_review_app",
          force: true,
        )

        run "chmod a+x bin/setup_review_app"
      end

      private

      def app_name
        Rails.application.class.parent_name.demodulize.underscore.dasherize
      end
    end
  end
end
