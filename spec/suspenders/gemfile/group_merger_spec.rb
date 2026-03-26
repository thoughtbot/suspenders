# frozen_string_literal: true

RSpec.describe Suspenders::Gemfile::GroupMerger do
  describe ".merge" do
    it "merges duplicate group blocks" do
      gemfile = <<~GEMFILE
        source "https://rubygems.org"

        gem "rails"

        group :development, :test do
          gem "debug"
          gem "brakeman", require: false
        end

        group :development do
          gem "web-console"
        end

        gem "sidekiq"

        group :development, :test do
          gem "factory_bot_rails"
          gem "rspec-rails", "~> 8.0.0"
        end
      GEMFILE

      result = described_class.merge(gemfile)

      expect(result).to eq <<~GEMFILE
        source "https://rubygems.org"

        gem "rails"

        group :development, :test do
          gem "debug"
          gem "brakeman", require: false
          gem "factory_bot_rails"
          gem "rspec-rails", "~> 8.0.0"
        end

        group :development do
          gem "web-console"
        end

        gem "sidekiq"
      GEMFILE
    end

    it "merges duplicate development groups" do
      gemfile = <<~GEMFILE
        group :development do
          gem "web-console"
        end

        gem "sidekiq"

        group :development do
          gem "hotwire-spark"
        end
      GEMFILE

      result = described_class.merge(gemfile)

      expect(result).to eq <<~GEMFILE
        group :development do
          gem "web-console"
          gem "hotwire-spark"
        end

        gem "sidekiq"
      GEMFILE
    end

    it "preserves comments within groups" do
      gemfile = <<~GEMFILE
        group :development, :test do
          # Debugging
          gem "debug"
        end

        group :development, :test do
          # Testing
          gem "rspec-rails"
        end
      GEMFILE

      result = described_class.merge(gemfile)

      expect(result).to eq <<~GEMFILE
        group :development, :test do
          # Debugging
          gem "debug"
          # Testing
          gem "rspec-rails"
        end
      GEMFILE
    end

    it "returns the gemfile unchanged when there are no duplicates" do
      gemfile = <<~GEMFILE
        gem "rails"

        group :development, :test do
          gem "debug"
        end

        group :test do
          gem "capybara"
        end
      GEMFILE

      result = described_class.merge(gemfile)

      expect(result).to eq gemfile
    end
  end
end
