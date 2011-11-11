require 'bundler/gem_helper'
require 'cucumber/rake/task'

Bundler::GemHelper.install_tasks

TEST_PROJECT = 'test_project'

Cucumber::Rake::Task.new

desc 'Run the test suite'
task :default => ['cucumber']
