require 'simplecov'
SimpleCov.start 'rails'

ENV['RAILS_ENV'] = 'test'

require File.expand_path('../../config/environment', __FILE__)

require 'rspec/rails'
require 'webmock/rspec'

Dir[Rails.root.join('spec/support/**/*.rb')].each { |file| require file }

RSpec.configure do |config|
  config.expect_with(:rspec) { |c| c.syntax = :expect }
  config.include Features, type: :feature
  config.infer_base_class_for_anonymous_controllers = false
  config.order = 'random'
  config.use_transactional_fixtures = false
end

Capybara.javascript_driver = :webkit
WebMock.disable_net_connect!(allow_localhost: true)
