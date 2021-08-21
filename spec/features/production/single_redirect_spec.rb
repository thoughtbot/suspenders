require "spec_helper"

RSpec.describe "suspenders:production:single_redirect", type: :feature do
  context "generate" do
    it "adds Rack::CanonicalHost to the production middleware" do
      with_app { generate("suspenders:production:single_redirect") }
      middleware_canonical_host = %r{config.middleware.use Rack::CanonicalHost, ENV.fetch\("APPLICATION_HOST"\)}

      expect("config/environments/production.rb").to match_contents(
        middleware_canonical_host
      )
    end
  end

  context "destroy" do
    it "removes Rack::CanonicalHost from the production middleware" do
      with_app { destroy("suspenders:production:single_redirect") }
      middleware_canonical_host = %r{config.middleware.use Rack::CanonicalHost, ENV.fetch\("APPLICATION_HOST"\)}

      expect("config/environments/production.rb").not_to match_contents(
        middleware_canonical_host
      )
    end
  end
end
