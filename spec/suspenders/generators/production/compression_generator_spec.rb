require "spec_helper"

RSpec.describe Suspenders::Production::CompressionGenerator, type: :generator do
  describe "invoke" do
    it "adds Rack::Deflater to the middleware" do
      with_fake_app do
        invoke! Suspenders::Production::CompressionGenerator

        expect("config/environments/production.rb")
          .to match_contents(%r{config.middleware.use Rack::Deflater})
      end
    end
  end

  describe "revoke" do
    it "removes Rack::Deflater from the middleware" do
      with_fake_app do
        invoke_then_revoke! Suspenders::Production::CompressionGenerator

        expect("config/environments/production.rb")
          .not_to match_contents(%r{Rack::Deflater})
      end
    end
  end
end
