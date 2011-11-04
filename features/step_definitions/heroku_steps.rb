Then /^the "([^"]*)" heroku app should exist$/ do |app_name|
  FakeHeroku.should have_created_app(app_name)
end
