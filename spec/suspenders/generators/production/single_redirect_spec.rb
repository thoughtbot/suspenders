require "spec_helper"

RSpec.describe Suspenders::Production::SingleRedirect, type: :generator do
  describe "invoke" do
    it "adds Rack::CanonicalHost to the production middleware" do
      with_fake_app do
        invoke! Suspenders::Production::SingleRedirect

        middleware_canonical_host =
          "config.middleware.use Rack::CanonicalHost, " \
          'ENV.fetch("APPLICATION_HOST")'

        expect("config/environments/production.rb")
          .to match_contents(/#{Regexp.escape(middleware_canonical_host)}/)
      end
    end
  end

  describe "revoke" do
    it "removes Rack::CanonicalHost from the production middleware" do
      with_fake_app do
        invoke_then_revoke! Suspenders::Production::SingleRedirect

        middleware_canonical_host =
          "config.middleware.use Rack::CanonicalHost, " \
          'ENV.fetch("APPLICATION_HOST")'

        expect("config/environments/production.rb")
          .not_to match_contents(/#{Regexp.escape(middleware_canonical_host)}/)
      end
    end
  end
end
