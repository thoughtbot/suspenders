#!/usr/bin/env ruby
require "fileutils"
require "bundler"

# path to your application root.
APP_ROOT = File.expand_path("..", __dir__)

def system!(*args)
  system(*args, exception: true)
end

def using_node?
  File.exist? "package.json"
end

FileUtils.chdir APP_ROOT do
  puts "== Installing dependencies =="
  system! "gem install bundler --conservative"
  system("bundle check") || system!("bundle install")
  system("yarn install --check-files") if using_node?

  puts "\n== Preparing database and adding development seed data =="
  if File.exist? "lib/tasks/dev.rake"
    system! "bin/rails dev:prime"
  else
    system! "bin/rails db:prepare"
  end

  if Bundler.rubygems.find_name("sprockets")
    puts "\n== Generating assets =="
    system! "bin/rails assets:clobber assets:precompile"
  end

  puts "\n== Removing old logs and tempfiles =="
  system! "bin/rails log:clear tmp:clear"

  puts "\n== Restarting application server =="
  system! "bin/rails restart"
end
