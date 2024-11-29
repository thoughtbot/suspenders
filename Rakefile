require "bundler/setup"
require "bundler/gem_tasks"
require "minitest/test_task"
require "standard/rake"

require File.expand_path("test/dummy/config/application", __dir__)

Rails.application.load_tasks

Minitest::TestTask.create(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.warning = false
  t.test_globs = ["test/**/*_test.rb"]
end

task default: %i[test standard]
