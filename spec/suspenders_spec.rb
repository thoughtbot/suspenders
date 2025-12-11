# frozen_string_literal: true

RSpec.describe Suspenders do
  it "has a version number" do
    expect(Suspenders::VERSION).not_to be nil
  end

  describe Suspenders::CLI do
    let(:stub_success) {
      allow_any_instance_of(Suspenders::CLI).to receive(:system).and_return(true)
    }

    before do
      stub_success
    end

    describe ".run" do
      it "calls rails new with expected arguments" do
        template_path = File.expand_path("../lib/templates/web.rb", __dir__)
        args = [
          "rails",
          "new",
          "app_name",
          "-d=postgresql",
          "--skip-test",
          "--skip-solid",
          "-m=#{template_path}"
        ]

        expect_any_instance_of(Suspenders::CLI).to receive(:system).with(*args)

        Suspenders::CLI.run("app_name")
      end

      it "returns true" do
        result = Suspenders::CLI.run("app_name")

        expect(result).to eq true
      end

      context "when rails does not exist" do
        let(:stub_failure) {
          allow_any_instance_of(Suspenders::CLI).to receive(:system).with(
            "which", "rails", out: File::NULL, err: File::NULL
          ).and_return(false)
        }

        before do
          stub_failure
        end

        it "raises" do
          expect {
            Suspenders::CLI.run("app_name")
          }.to raise_error(Suspenders::Error, "Rails not found. Install with: gem install rails")
        end
      end

      context "when rails fails to install" do
        let(:app_name) { "app_name" }
        let(:template_path) { File.expand_path("../lib/templates/web.rb", __dir__) }
        let(:args) {
          [
            "rails",
            "new",
            app_name,
            "-d=postgresql",
            "--skip-test",
            "--skip-solid",
            "-m=#{template_path}"
          ]
        }
        let(:stub_failure) {
          allow_any_instance_of(Suspenders::CLI).to receive(:system).with(*args).and_return(false)
        }

        before do
          stub_failure
        end

        it "raises" do
          expect {
            Suspenders::CLI.run(app_name)
          }.to raise_error(Suspenders::Error, "Failed to create Rails app")
        end
      end
    end
  end
end
