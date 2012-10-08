require 'aruba/cucumber'

When 'I run rake' do
  in_current_dir do
    run 'bundle exec rake'
  end
end

When 'I run the rake task "$task_name"' do |task_name|
  in_current_dir do
    run "bundle exec rake #{task_name}"
  end
end

When 'I generate "$generator_with_args"' do |generator_with_args|
  in_current_dir do
    run "bundle exec rails generate #{generator_with_args}"
  end
end

Then 'I see a successful response in the shell' do
  assert_exit_status(0)
end

When 'I drop and create the required databases' do
  in_current_dir do
    run 'bundle exec rake db:drop RAILS_ENV=test'
    run 'bundle exec rake db:drop'
    run 'bundle exec rake db:create RAILS_ENV=test'
    run 'bundle exec rake db:create'
  end
end

When 'I suspend a project called "$project_name"' do |project_name|
  suspenders_bin = File.expand_path(File.join('..', '..', 'bin', 'suspenders'), File.dirname(__FILE__))
  run "#{suspenders_bin} #{project_name}"
  assert_exit_status(0)
end

When /^I suspend a project called "([^"]*)" with:$/ do |project_name, arguments_table|
  suspenders_bin = File.expand_path(File.join('..', '..', 'bin', 'suspenders'), File.dirname(__FILE__))
  arguments = arguments_table.hashes.inject([]) do |accum, argument|
    accum << "#{argument['argument']}=#{argument['value']}"
  end.join
  run "#{suspenders_bin} #{project_name} #{arguments}"
  assert_exit_status(0)
end

When 'I cd to the "$test_project" root' do |dirname|
  cd dirname
end

Then 'I can cleanly rake the project' do
  steps %{
    And I run the rake task "db:create"
    And I run the rake task "db:migrate"
    And I run the rake task "db:test:prepare"
    And I run the rake task "cucumber"
    Then I see a successful response in the shell
  }
end

Then /^"(.*)" should not be installed$/ do |gem_name|
  in_current_dir do
    system("bundle show #{gem_name} 2>&1 > /dev/null").should be_false
  end
end

Then /^"(.*)" should not be included in "(.*)"$/ do |content, file_path|
  check_file_content file_path, content, false
end

Then /^the "([^"]*)" Heroku app should exist$/ do |app_name|
  FakeHeroku.should have_created_app(app_name)
end

Then /^the "([^"]*)" Github repo should exist$/ do |repo_name|
  FakeGithub.should have_created_repo(repo_name)
end
