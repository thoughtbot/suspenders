#!/usr/bin/env ruby

require_relative "../../lib/suspenders/version"
require_relative "../../lib/suspenders/cli"

module Suspenders
  class Error < StandardError; end
end

if ARGV[0].nil? || ARGV[0].empty?
  puts "Error: Application name required"
  puts "Usage: suspenders APP_NAME"
  exit 1
end

if ARGV.length > 1
  puts "Error: Too many arguments (#{ARGV.length} given)"
  puts "Usage: suspenders APP_NAME"
  exit 1
end

app_name = ARGV[0]

begin
  Suspenders::CLI.run(app_name)
  exit 0
rescue Suspenders::Error => e
  abort "Error: #{e.message}"
end
