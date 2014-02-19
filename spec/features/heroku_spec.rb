require 'spec_helper'

feature 'Heroku' do
  scenario 'Suspend a project with --heroku=true' do
    run_suspenders('--heroku=true')

    expect(FakeHeroku).to have_gem_included(project_path, 'rails_12factor')
    expect(FakeHeroku).to have_created_app_for('staging')
    expect(FakeHeroku).to have_created_app_for('production')
    expect(FakeHeroku).to have_configured_vars('staging', 'SECRET_KEY_BASE')
    expect(FakeHeroku).to have_configured_vars('production', 'SECRET_KEY_BASE')
  end
end
