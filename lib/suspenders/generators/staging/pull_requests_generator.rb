require_relative "../base"

module Suspenders
  module Staging
    class PullRequestsGenerator < Generators::Base
      def configure_heroku_staging_pr_pipeline_host
        inject_template_into_file(
          "config/environments/production.rb",
          "partials/pull_requests_config.rb",
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
    end
  end
end
