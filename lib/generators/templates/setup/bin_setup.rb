#!/usr/bin/env ruby
require "fileutils"
require "open3"
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
  if ENV["CI"].nil?
    puts "\n== Installing Homebrew Bundle from Brewfile =="
    system! "brew bundle"

    puts "\n== Starting postgresql@15 =="
    system! "brew services restart postgresql@15"

    puts "\n== Starting redis =="
    system! "brew services restart redis"

    _, _, status = Open3.capture3("which asdf")
    if status.success?
      puts "\n== Installing tool dependecies via asdf =="
      system! "asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby"
      system! "asdf plugin-add nodejs https://github.com/asdf-vm/asdf-nodejs" if using_node?
      system! "asdf plugin-add yarn https://github.com/twuni/asdf-yarn" if using_node?
      system! "asdf plugin-update --all"
      system! "asdf install"
    end
  end

  puts "\n== Installing dependencies =="
  system! "gem install bundler --conservative"
  system("bundle check") || system!("bundle install")
  system("yarn install --check-files") if using_node?

  puts "\n== Preparing database and adding development seed data =="
  system! "bin/rails dev:prime"

  if Bundler.rubygems.find_name("sprockets")
    puts "\n== Generating assets =="
    system! "bin/rails assets:clobber assets:precompile"
  end

  # https://github.com/rails/rails/pull/47719/files
  puts "\n== Setup test environment =="
  system! "bin/rails test:prepare"

  puts "\n== Removing old logs and tempfiles =="
  system! "bin/rails log:clear tmp:clear"

  puts "\n== Restarting application server =="
  system! "bin/rails restart"
end
