ENV['TESTING'] = 'true'

require 'capybara/rspec'
require 'bundler/setup'
require suspenders_file_path('generators', 'app_generator')
require suspenders_file_path('actions')
require suspenders_file_path('app_builder')

templates_root = File.expand_path(File.join("..", "templates"), File.dirname(__FILE__))
Suspenders::AppGenerator.source_root templates_root
Suspenders::AppGenerator.source_paths << Rails::Generators::AppGenerator.source_root << templates_root

Bundler.require(:default, :test)

Dir['./spec/support/**/*.rb'].each { |file| require file }

def suspenders_file_path(*args)
  File.expand_path(File.join('..', 'lib', 'suspenders', *args), File.dirname(__FILE__))
end
