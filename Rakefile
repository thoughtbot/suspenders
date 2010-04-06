require 'rake'
require 'cucumber/rake/task'

TEST_PROJECT = 'test_project'

Cucumber::Rake::Task.new

namespace :test do
  desc "A full suspenders app's test suite"
  task :full => ['generate:suspenders', 'generate:finish', 'cucumber', 'destroy:suspenders']
end

namespace :generate do
  desc 'Suspend a new project'
  task :suspenders do
    sh './bin/suspension', TEST_PROJECT
  end

  desc 'Finishing touches'
  task :finish do
    open(File.join(TEST_PROJECT, 'config', 'environments', 'cucumber.rb'), 'a') do |f|
      f.puts "config.action_mailer.default_url_options = { :host => 'localhost:3000' }"
    end

    routes_file = IO.read(File.join(TEST_PROJECT, 'config', 'routes.rb')).split("\n")
    routes_file = [routes_file[0]] + [%{map.root :controller => 'clearance/sessions', :action => 'new'}] + routes_file[1..-1]
    open(File.join(TEST_PROJECT, 'config', 'routes.rb'), 'w') do |f|
      f.puts routes_file.join("\n")
    end
  end
end

namespace :destroy do
  desc 'Remove a suspended project'
  task :suspenders do
    FileUtils.rm_rf TEST_PROJECT
  end
end

desc 'Run the test suite'
task :default => ['test:full']
