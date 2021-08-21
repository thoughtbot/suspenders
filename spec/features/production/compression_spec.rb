require "spec_helper"

RSpec.describe "suspenders:production:compression", type: :feature do
  context "generate" do
    it "adds Rack::Deflater to the middleware" do
      with_app { generate("suspenders:production:compression") }

      expect("config/environments/production.rb").to match_contents(
        %r{config.middleware.use Rack::Deflater}
      )
    end
  end

  context "destroy" do
    it "removes Rack::Deflater to the middleware" do
      with_app { destroy("suspenders:production:compression") }

      expect("config/environments/production.rb").not_to match_contents(
        %r{Rack::Deflater}
      )
    end
  end
end
