require 'spec_helper'

feature 'Heroku' do
  scenario 'Suspend a project with --heroku=true' do
    run_suspenders('--heroku=true')

    expect(FakeHeroku).to have_gem_included(project_path, 'rails_12factor')
    expect(FakeHeroku).to have_created_app_for('staging', region: 'us')
    expect(FakeHeroku).to have_created_app_for('production', region: 'us')
    expect(FakeHeroku).to have_configured_vars('staging', 'SECRET_KEY_BASE')
    expect(FakeHeroku).to have_configured_vars('production', 'SECRET_KEY_BASE')

    bin_setup = IO.read("#{project_path}/bin/setup")
    app_name = SuspendersTestHelpers::APP_NAME

    expect(bin_setup).to include("heroku join --app #{app_name}-staging")
    expect(bin_setup).to include("heroku join --app #{app_name}-production")

    bin_deploy = IO.read("#{project_path}/bin/deploy")

    expect(bin_deploy).to include("heroku run rake db:migrate")

    readme = IO.read("#{project_path}/README.md")

    expect(readme).to include("./bin/deploy staging")
    expect(readme).to include("./bin/deploy production")
  end

  scenario 'Suspend a project with --heroku=true --heroku-region=eu' do
    run_suspenders('--heroku=true --heroku-region=eu')

    expect(FakeHeroku).to have_created_app_for('staging', region: 'eu')
    expect(FakeHeroku).to have_created_app_for('production', region: 'eu')
  end
end
