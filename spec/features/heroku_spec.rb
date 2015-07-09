require "spec_helper"

RSpec.describe "Heroku" do
  it "suspends a project for Heroku" do
    expect(FakeHeroku).to(
      have_gem_included(project_path, "rails_stdout_logging")
    )
    expect(FakeHeroku).to have_created_app_for("staging")
    expect(FakeHeroku).to have_created_app_for("production")
    expect(FakeHeroku).to have_configured_vars("staging", "SECRET_KEY_BASE")
    expect(FakeHeroku).to have_configured_vars("production", "SECRET_KEY_BASE")
  end

  it "suspends a project with extra Heroku flags" do
    run_suspenders(%{--heroku-flags="--region eu"})

    expect(FakeHeroku).to have_created_app_for("staging", "--region eu")
    expect(FakeHeroku).to have_created_app_for("production", "--region eu")
  end
end
