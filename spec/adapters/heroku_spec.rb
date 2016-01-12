require "spec_helper"

module Suspenders
  module Adapters
    RSpec.describe Heroku do
      it "sets the heroku remotes" do
        setup_file = "bin/setup"
        app_builder = double(app_name: app_name)
        allow(app_builder).to receive(:append_file)

        Heroku.new(app_builder).set_heroku_remotes

        expect(app_builder).to have_received(:append_file).
          with(setup_file, /heroku join --app #{app_name.dasherize}-production/)
        expect(app_builder).to have_received(:append_file).
          with(setup_file, /heroku join --app #{app_name.dasherize}-staging/)
      end

      it "sets up the heroku specific gems" do
        app_builder = double(app_name: app_name)
        allow(app_builder).to receive(:inject_into_file)

        Heroku.new(app_builder).set_up_heroku_specific_gems

        expect(app_builder).to have_received(:inject_into_file).
          with("Gemfile", /rails_stdout_logging/, anything)
      end

      it "sets the heroku rails secrets" do
        app_builder = double(app_name: app_name)
        allow(app_builder).to receive(:run)

        Heroku.new(app_builder).set_heroku_rails_secrets

        expect(app_builder).to(
          have_configured_var("staging", "SECRET_KEY_BASE"),
        )
        expect(app_builder).to(
          have_configured_var("production", "SECRET_KEY_BASE"),
        )
      end

      def app_name
        SuspendersTestHelpers::APP_NAME
      end

      def have_configured_var(remote_name, var)
        have_received(:run).with(/config:add #{var}=.+ --remote #{remote_name}/)
      end
    end
  end
end
