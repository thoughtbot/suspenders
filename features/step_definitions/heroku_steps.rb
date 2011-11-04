Then /^the "([^"]*)" heroku app should exist$/ do |app_name|
  commands_path = File.expand_path(File.join('..', '..', 'tmp', 'heroku_commands'), File.dirname(__FILE__))
  File.open(commands_path, 'r').read.should include("create #{app_name}")
end
