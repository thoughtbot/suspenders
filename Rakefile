require "bundler/setup"
require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "standard/rake"

RSpec::Core::RakeTask.new(:rspec)

desc "Run the test suite"
task default: [:rspec, :standard]
