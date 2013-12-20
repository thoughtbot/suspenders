require 'capybara/rspec'
require 'bundler/setup'
ENV['TEST'] = '1'

require File.expand_path(File.join('..', 'lib', 'suspenders'), File.dirname(__FILE__))

templates_root = File.expand_path(File.join("..", "templates"), File.dirname(__FILE__))
Suspenders::AppGenerator.source_root templates_root
Suspenders::AppGenerator.source_paths << Rails::Generators::AppGenerator.source_root << templates_root

Bundler.require(:default, :test)

Dir['./spec/support/**/*.rb'].each { |file| require file }

RSpec.configure do |config|
  config.include SuspendersTestHelpers

  config.after(:all) do
    drop_dummy_database
    clean_suspended_directory
  end
end
