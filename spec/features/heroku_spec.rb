require "spec_helper"

RSpec.describe "Heroku" do
  context "--heroku" do
    before(:all) do
      clean_up
      run_suspenders("--heroku=true")
      setup_app_dependencies
    end

    it "suspends a project for Heroku" do
      app_name = SuspendersTestHelpers::APP_NAME.dasherize

      expect(FakeHeroku).to have_created_app_for("staging")
      expect(FakeHeroku).to have_created_app_for("production")
      expect(FakeHeroku).to have_configured_vars("staging", "SECRET_KEY_BASE")
      expect(FakeHeroku).to have_configured_vars(
        "production",
        "SECRET_KEY_BASE",
      )
      %w(staging production).each do |env|
        expect(FakeHeroku).to have_configured_vars(env, "APPLICATION_HOST")
        expect(FakeHeroku).to have_configured_vars(env, "HONEYBADGER_ENV")
      end
      expect(FakeHeroku).to have_setup_pipeline_for(app_name)

      bin_setup_path = "#{project_path}/bin/setup"
      bin_setup = IO.read(bin_setup_path)

      expect(bin_setup).to assert_access_to_heroku_app("#{app_name}-production")
      expect(bin_setup).to assert_access_to_heroku_app("#{app_name}-staging")
      expect(bin_setup).to match(/^git config heroku.remote staging/)
      expect("bin/setup").to be_executable

      readme = IO.read("#{project_path}/README.md")

      expect(readme).to include("./bin/deploy staging")
      expect(readme).to include("./bin/deploy production")
    end
  end

  context "--heroku with region flag" do
    before(:all) do
      clean_up
      run_suspenders(%{--heroku=true --heroku-flags="--region eu"})
      setup_app_dependencies
    end

    it "suspends a project with extra Heroku flags" do
      expect(FakeHeroku).to have_created_app_for("staging", "--region eu")
      expect(FakeHeroku).to have_created_app_for("production", "--region eu")
    end
  end

  def assert_access_to_heroku_app(app_name)
    match(/^if heroku apps:info --app #{app_name}/)
  end

  def clean_up
    drop_dummy_database
    remove_project_directory
    FakeHeroku.clear!
  end
end
