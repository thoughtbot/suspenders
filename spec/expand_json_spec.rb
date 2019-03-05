require "spec_helper"

RSpec.describe Suspenders::Actions::ExpandJson do
  let(:destination_root) { File.join(root_path, "tmp") }
  let(:destination_file_name) { "app.json" }
  let(:destination_path) { File.join(destination_root, destination_file_name) }

  before do
    FileUtils.rm destination_path if File.exist?(destination_path)
  end

  describe "#invoke!" do
    context "when calling multiple times with the same root key" do
      before do
        described_class.new(
          destination_root,
          destination_file_name,
          env: {
            SMTP_ADDRESS: { required: true },
          },
        ).invoke!
      end

      it "deep merges the hash" do
        described_class.new(
          destination_root,
          destination_file_name,
          env: {
            HEROKU_APP_NAME: { required: true },
          },
        ).invoke!

        expected = <<~JSON
          {
            "env": {
              "SMTP_ADDRESS": {
                "required": true
              },
              "HEROKU_APP_NAME": {
                "required": true
              }
            }
          }
        JSON
        expect(existing_json).to eq(expected.chomp)
      end
    end
  end

  describe "#revoke!" do
    before do
      described_class.new(
        destination_root,
        destination_file_name,
        env: {
          foo: { required: true },
          bar: { required: true },
        },
      ).invoke!
    end

    it "removes data from the JSON" do
      described_class.new(
        destination_root,
        destination_file_name,
        env: {
          foo: { required: true },
        },
      ).revoke!

      expected = <<~JSON
        {
          "env": {
            "bar": {
              "required": true
            }
          }
        }
      JSON
      expect(existing_json).to eq(expected.chomp)
    end
  end

  private

  def existing_json
    IO.read(destination_path)
  end
end
