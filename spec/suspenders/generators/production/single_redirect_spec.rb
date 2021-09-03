require "spec_helper"

RSpec.describe Suspenders::Production::SingleRedirect, type: :generator do
  describe "invoke" do
    it "adds Rack::CanonicalHost to the production middleware" do
      with_fake_app do
        invoke! Suspenders::Production::SingleRedirect

        middleware_canonical_host =
          %r{config.middleware.use Rack::CanonicalHost, ENV.fetch\("APPLICATION_HOST"\)}

        expect("config/environments/production.rb")
          .to match_contents(middleware_canonical_host)
      end
    end
  end

  describe "destroy" do
    it "removes Rack::CanonicalHost from the production middleware" do
      with_fake_app do
        invoke! Suspenders::Production::SingleRedirect
        revoke! Suspenders::Production::SingleRedirect

        middleware_canonical_host =
          %r{config.middleware.use Rack::CanonicalHost, ENV.fetch\("APPLICATION_HOST"\)}

        expect("config/environments/production.rb")
          .not_to match_contents(middleware_canonical_host)
      end
    end
  end
end
