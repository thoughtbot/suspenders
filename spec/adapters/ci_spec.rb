require "spec_helper"

module Suspenders
  module Adapters
    RSpec.describe Ci do
      context "travis" do
        it "creates .travis.yml" do
          src_file = "travis.yml.erb"
          dest_file = ".travis.yml"
          app_builder = double(:app_builder)
          allow(app_builder).to receive(:template)

          Ci.new(app_builder).setup_ci("travis")

          expect(app_builder).to have_received(:template).with(src_file, dest_file)
        end

        it "adds the properly formatted deploy commands" do
          config_file = ".travis.yml"
          app_builder = double(:app_builder)
          allow(app_builder).to receive(:append_file)

          Ci.new(app_builder).configure_automatic_deployment("travis")

          expect(app_builder).to have_received(:append_file).with(config_file, anything)
        end
      end

      context "circle" do
        it "creates circle.yml" do
          src_file = "circle.yml.erb"
          dest_file = "circle.yml"
          app_builder = double(:app_builder)
          allow(app_builder).to receive(:template)

          Ci.new(app_builder).setup_ci("circle")

          expect(app_builder).to have_received(:template).with(src_file, dest_file)
        end

        it "adds the properly formatted deploy commands" do
          config_file = "circle.yml"
          app_builder = double(:app_builder)
          allow(app_builder).to receive(:append_file)

          Ci.new(app_builder).configure_automatic_deployment("circle")

          expect(app_builder).to have_received(:append_file).with(config_file, anything)
        end
      end
    end
  end
end
