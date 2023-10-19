# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require_relative "../test/dummy/config/environment"
ActiveRecord::Migrator.migrations_paths = [File.expand_path("../test/dummy/db/migrate", __dir__)]
require "rails/test_help"

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

  def remove_file_if_exists(file)
    path = app_root file

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

  def touch(file)
    path = app_root file

    FileUtils.touch path
  end
end
