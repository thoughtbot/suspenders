require 'bundler/setup'
require 'bundler/gem_tasks'
require 'cucumber/rake/task'
require 'rspec/core/rake_task'

Cucumber::Rake::Task.new
RSpec::Core::RakeTask.new(:rspec)

desc 'Run the test suite'
task :default => [:rspec, :cucumber]
