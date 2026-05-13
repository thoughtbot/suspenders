# frozen_string_literal: true

RSpec.describe Suspenders::GemfileConsolidator do
  describe ".call" do
    it "merges duplicate group blocks and preserves top-level gems" do
      input = <<~GEMFILE
        source "https://rubygems.org"

        gem "rails"

        group :development, :test do
          gem "debug"
        end

        group :development do
          gem "web-console"
        end
        gem "sidekiq"

        group :test do
          gem "capybara"
        end

        group :development do
          gem "hotwire-spark"
        end

        group :development, :test do
          gem "rspec-rails"
        end
      GEMFILE

      expected = <<~GEMFILE
        source "https://rubygems.org"

        gem "rails"

        gem "sidekiq"

        group :development, :test do
          gem "debug"

          gem "rspec-rails"
        end

        group :development do
          gem "web-console"

          gem "hotwire-spark"
        end

        group :test do
          gem "capybara"
        end
      GEMFILE

      expect(described_class.call(input)).to eq(expected)
    end
  end
end
