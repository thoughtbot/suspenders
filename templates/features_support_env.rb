require 'spork'

Spork.prefork do
  ENV['RAILS_ENV'] ||= 'test'
  require File.expand_path(File.dirname(__FILE__) + '/../../config/environment')
  require 'cucumber/rails'

  Capybara.default_selector = :css
  Capybara.javascript_driver = :webkit
  DatabaseCleaner.strategy = :truncation
end

Spork.each_run do
  After do
    DatabaseCleaner.clean
  end
end
