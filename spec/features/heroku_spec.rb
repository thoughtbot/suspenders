require "spec_helper"

describe "Heroku" do
  it "suspends a project for Heroku" do
    run_suspenders("--heroku=true")

    expect(FakeHeroku).to(
      have_gem_included(project_path, "rails_stdout_logging")
    )
    expect(FakeHeroku).to have_created_app_for("staging")
    expect(FakeHeroku).to have_created_app_for("production")
    expect(FakeHeroku).to have_configured_vars("staging", "SECRET_KEY_BASE")
    expect(FakeHeroku).to have_configured_vars("production", "SECRET_KEY_BASE")

    bin_setup_path = "#{project_path}/bin/setup"
    bin_setup = IO.read(bin_setup_path)
    app_name = SuspendersTestHelpers::APP_NAME.dasherize

    expect(bin_setup).to include("heroku join --app #{app_name}-production")
    expect(bin_setup).to include("heroku join --app #{app_name}-staging")
    expect(File.stat(bin_setup_path)).to be_executable

    bin_deploy_path = "#{project_path}/bin/deploy"
    bin_deploy = IO.read(bin_deploy_path)

    expect(bin_deploy).to include("heroku run rake db:migrate")
    expect(File.stat(bin_deploy_path)).to be_executable

    readme = IO.read("#{project_path}/README.md")

    expect(readme).to include("./bin/deploy staging")
    expect(readme).to include("./bin/deploy production")
  end

  it "suspends a project with extra Heroku flags" do
    run_suspenders(%{--heroku=true --heroku-flags="--region eu"})

    expect(FakeHeroku).to have_created_app_for("staging", "--region eu")
    expect(FakeHeroku).to have_created_app_for("production", "--region eu")
  end
end
