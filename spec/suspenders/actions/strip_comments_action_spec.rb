require "spec_helper"
require "suspenders/actions/strip_comments_action"

RSpec.describe Suspenders::Actions::StripCommentsAction do
  describe ".call" do
    it "removes a comment at indentation 0" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        # Comment 1
        Rails.application.configure do
          config.force_ssl = true
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
          config.force_ssl = true
        end
      SOURCE
    end

    it "removes a comment at indentation 2" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        Rails.application.configure do
          # A comment
          config.force_ssl = true
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
          config.force_ssl = true
        end
      SOURCE
    end

    it "removes two comments at indentation 2" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        Rails.application.configure do
          # Comment 1
          # Comment 2
          config.force_ssl = true
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
          config.force_ssl = true
        end
      SOURCE
    end

    it "removes inline comments" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        Rails.application.configure do
          config.force_ssl = true # A comment here
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
          config.force_ssl = true
        end
      SOURCE
    end

    it "does not remove non-comments that could be confused as comments" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        Rails.application.configure do
          str = <<~STR
            # Not a comment
          STR
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
          str = <<~STR
            # Not a comment
          STR
        end
      SOURCE
    end

    it "preserves the newline at the end of the file" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        # Comment 1
        Rails.application.configure do
          config.force_ssl = true
        end
      SOURCE

      expect(source).to eq(<<~SOURCE)
        Rails.application.configure do
          config.force_ssl = true
        end
      SOURCE
    end

    it "removes comments that delineate blocks of code" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        # Comment 1
        Rails.application.configure do
          # Comment 1
          config.force_ssl = true
          config.cache_store = :null_store

          # Comment 2
          config.eager_load = true
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
          config.force_ssl = true
          config.cache_store = :null_store
          config.eager_load = true
        end
      SOURCE
    end

    it "removes blank lines with whitespace" do
      source = <<~SOURCE
        # One
        config.n = true
        #{" " * 10}
        # Two
        config.t = true
      SOURCE

      source = Suspenders::Actions::StripCommentsAction.call(source)

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        config.n = true
        config.t = true
      SOURCE
    end

    it "removes trailing whitespace" do
      source = <<~SOURCE
        method do
          config.n = true#{" " * 5}
          config.t = true
        end
      SOURCE

      source = Suspenders::Actions::StripCommentsAction.call(source)

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        method do
          config.n = true
          config.t = true
        end
      SOURCE
    end

    it "removes a block of comments + newlines + other comments" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        Rails.application.configure do
          config.cache_classes = true

          # Comment 1

          # Comment 2
          config.load_defaults 6.0
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
          config.cache_classes = true

          config.load_defaults 6.0
        end
      SOURCE
    end

    it "removes a block of comments + newlines + other comments, and joins assignments" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        Rails.application.configure do
          config.cache_classes = true

          # Comment 1

          # Comment 2
          config.other = false
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
          config.cache_classes = true
          config.other = false
        end
      SOURCE
    end

    it "removes a block of comments + newlines after indentation changes" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        Rails.application.configure do
          # Comment 1

          # Comment 2
          config.cache_classes = true
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
          config.cache_classes = true
        end
      SOURCE
    end

    it "removes bigger blocks of comments + newlines + other comments" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        module Foobar
          class Application < Rails::Application
            # Comment here
            config.load_defaults 6.0

            # Coment here
            # Comment here

            # Comment here
            config.generators.system_tests = nil
          end
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        module Foobar
          class Application < Rails::Application
            config.load_defaults 6.0

            config.generators.system_tests = nil
          end
        end
      SOURCE
    end

    it "removes leading newlines from classes, modules, and blocks" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        module Mod\n\n
          class MyClass\n\n
            MyGem.application.configure do |config|\n\n
              config.option1 = true

              config.option2 = false
            end
          end
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        module Mod
          class MyClass
            MyGem.application.configure do |config|
              config.option1 = true
              config.option2 = false
            end
          end
        end
      SOURCE
    end

    it "removes comments and newlines from the beginning of the source" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        # The test environment is used exclusively to run your application's
        # test suite.

        Rails.application.configure do
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        Rails.application.configure do
        end
      SOURCE
    end

    it "correctly handles removal of comments at indentation 0" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        # First require
        require_relative 'boot'

        require "rails"
        # Pick the frameworks you want:
        require "active_model/railtie"
        require "active_job/railtie"
        # require "rails/test_unit/railtie"

        # Require the gems listed in Gemfile, including any gems
        # you've limited to :test, :development, or :production.
        Bundler.require(*Rails.groups)

        module Foo
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        require_relative 'boot'

        require "rails"
        require "active_model/railtie"
        require "active_job/railtie"

        Bundler.require(*Rails.groups)

        module Foo
        end
      SOURCE
    end

    it "does not join assignments that are not preceded by other assignments" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        config.after_initialize do
          Bullet.rails_logger = true
        end

        config.action_mailer.delivery_method = :file

        config.action_mailer.perform_caching = false
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        config.after_initialize do
          Bullet.rails_logger = true
        end

        config.action_mailer.delivery_method = :file
        config.action_mailer.perform_caching = false
      SOURCE
    end

    it "handles nested begin correctly" do
      # There's an implicit "begin" block encompassing the entire code
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        # Comment here
        config.action_mailer.delivery_method = :file

        # Some comment
        config.action_mailer.perform_caching = false

        begin
          # Comment here
          config.action_mailer.first_call = :file

          # Some comment
          config.action_mailer.second_call = false
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        config.action_mailer.delivery_method = :file
        config.action_mailer.perform_caching = false

        begin
          config.action_mailer.first_call = :file
          config.action_mailer.second_call = false
        end
      SOURCE
    end

    it "handles nested blocks correctly" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        first_block do
          config.action_mailer.delivery_method = :file

          # Some comment
          config.action_mailer.perform_caching = false

          second_block do
            # Comment here
            config.action_mailer.delivery_method = :file

            # Some comment
            config.action_mailer.perform_caching = false
          end
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        first_block do
          config.action_mailer.delivery_method = :file
          config.action_mailer.perform_caching = false

          second_block do
            config.action_mailer.delivery_method = :file
            config.action_mailer.perform_caching = false
          end
        end
      SOURCE
    end

    it "removes blank lines before begin" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        begin

          foo.bar = 1

          begin

            bar.bat = 2
          end
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        begin
          foo.bar = 1

          begin
            bar.bat = 2
          end
        end
      SOURCE
    end

    it "removes comments right before the 'end' of a begin" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        begin
          foo.bar = 1

          # A comment
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        begin
          foo.bar = 1
        end
      SOURCE
    end

    it "removes comments right before the 'end' of a block" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        foo do |instance|
          instance.bar = 1

          # A comment
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        foo do |instance|
          instance.bar = 1
        end
      SOURCE
    end

    it "removes comments right before the 'end' of a class" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        class Foo
          class Bar
            # Another comment
          end

          # A comment
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        class Foo
          class Bar
          end
        end
      SOURCE
    end

    it "removes comments right before the 'end' of a module" do
      source = Suspenders::Actions::StripCommentsAction.call(<<~SOURCE)
        module Foo
          module Bar
            # Another comment
          end

          # A comment
        end
      SOURCE

      expect(source.chomp).to eq(<<~SOURCE.chomp)
        module Foo
          module Bar
          end
        end
      SOURCE
    end
  end
end
