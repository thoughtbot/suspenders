require 'spec_helper'

feature 'github repo' do
  scenario 'I suspend a project with --heroku=true' do
    repo_name = 'test'
    set_command_line_arguments("--heroku=true")
    run_suspenders

    expect(FakeHeroku).to have_created_app("#{SuspendersTestHelpers::APP_NAME}-staging")
    expect(FakeHeroku).to have_created_app("#{SuspendersTestHelpers::APP_NAME}-production")

    expect(FakeHeroku.configured_vars_for('staging')).to include('SECRET_KEY_BASE')
    expect(FakeHeroku.configured_vars_for('production')).to include('SECRET_KEY_BASE')
  end
end
