# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"
require "mocha/minitest"

# Load fixtures from the engine
if ActiveSupport::TestCase.respond_to?(:fixture_paths=)
  ActiveSupport::TestCase.fixture_paths = [File.expand_path("fixtures", __dir__)]
  ActionDispatch::IntegrationTest.fixture_paths = ActiveSupport::TestCase.fixture_paths
  ActiveSupport::TestCase.file_fixture_path = File.expand_path("fixtures", __dir__) + "/files"
  ActiveSupport::TestCase.fixtures :all
end

module Suspenders::TestHelpers
  def app_root(path)
    Rails.root.join path
  end

  def remove_file_if_exists(file, **options)
    root = options[:root]
    path = root ? file : app_root(file)

    FileUtils.rm path if File.exist? path
  end

  def remove_dir_if_exists(dir)
    path = app_root dir

    FileUtils.rm_r path if File.exist? path
  end

  def mkdir(dir)
    path = app_root dir

    FileUtils.mkdir path
  end

  # TODO: Update existing tests to use the content: option
  def touch(file, **options)
    content = options[:content]
    path = app_root file

    FileUtils.touch path

    if content
      File.write app_root(path), content
    end
  end

  def within_api_only_app(**options, &block)
    commented_out = options[:commented_out]
    set_config = if commented_out == true
      "# config.api_only = true"
    else
      "config.api_only = true"
    end

    backup_file "config/application.rb"
    application_config = <<~RUBY
      require_relative "boot"
      require "rails/all"

      Bundler.require(*Rails.groups)

      module Dummy
        class Application < Rails::Application
          config.load_defaults 7.1

          config.autoload_lib(ignore: %w(assets tasks))

          #{set_config}
        end
      end
    RUBY
    File.open(app_root("config/application.rb"), "w") { _1.write application_config }

    yield
  ensure
    restore_file "config/application.rb"
  end

  # TODO: Refactor existing tests to use this
  def with_test_suite(test_suite, &block)
    case test_suite
    when :minitest
      mkdir "test"
    when :rspec
      mkdir "spec"
      touch "spec/spec_helper.rb"
    else
      raise ArgumentError, "unknown test suite: #{test_suite.inspect}"
    end

    yield
  ensure
    remove_dir_if_exists "test"
    remove_dir_if_exists "spec"
  end

  def with_css_option(css, &block)
    case css
    when :postcss
      touch "postcss.config.js"
    when :tailwind
      touch "tailwind.config.js"
    else
      raise ArgumentError, "unknown css option: #{css.inspect}"
    end
    yield
  ensure
    remove_file_if_exists "postcss.config.js"
    remove_file_if_exists "tailwind.config.js"
  end

  def backup_file(file)
    FileUtils.copy app_root(file), app_root("#{file}.bak")
  end

  def restore_file(file)
    remove_file_if_exists(file)
    FileUtils.mv app_root("#{file}.bak"), app_root(file)
  end
end
