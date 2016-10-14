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
      expect(FakeHeroku).to have_configured_vars(
        "staging",
        "APPLICATION_HOST",
      )
      expect(FakeHeroku).to have_configured_vars(
        "production",
        "APPLICATION_HOST",
      )
      expect(FakeHeroku).to have_setup_pipeline_for(app_name)

      bin_setup_path = "#{project_path}/bin/setup"
      bin_setup = IO.read(bin_setup_path)

      expect(bin_setup).to match(/^if heroku join --app #{app_name}-production/)
      expect(bin_setup).to match(/^if heroku join --app #{app_name}-staging/)
      expect(bin_setup).to match(/^git config heroku.remote staging/)
      expect(File.stat(bin_setup_path)).to be_executable

      readme = IO.read("#{project_path}/README.md")

      expect(readme).to include("./bin/deploy staging")
      expect(readme).to include("./bin/deploy production")

      circle_yml_path = "#{project_path}/circle.yml"
      circle_yml = IO.read(circle_yml_path)

      expect(circle_yml).to include <<-YML.strip_heredoc
      deployment:
        staging:
          branch: master
          commands:
            - bin/deploy staging
      YML
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

  def clean_up
    drop_dummy_database
    remove_project_directory
    FakeHeroku.clear!
  end
end
