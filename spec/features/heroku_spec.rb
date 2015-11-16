require "spec_helper"

RSpec.describe "Heroku" do
  context "--heroku" do
    before(:all) do
      clean_up
      run_suspenders("--heroku=true")
    end

    it "suspends a project for Heroku" do
      app_name = SuspendersTestHelpers::APP_NAME.dasherize

      expect(FakeHeroku).to(
        have_gem_included(project_path, "rails_stdout_logging"),
      )
      expect(FakeHeroku).to have_created_app_for("staging")
      expect(FakeHeroku).to have_created_app_for("production")
      expect(FakeHeroku).to have_configured_vars("staging", "SECRET_KEY_BASE")
      expect(FakeHeroku).to have_configured_vars(
        "production",
        "SECRET_KEY_BASE",
      )

      bin_setup_path = "#{project_path}/bin/setup"
      bin_setup = IO.read(bin_setup_path)

      expect(bin_setup).to include("heroku join --app #{app_name}-production")
      expect(bin_setup).to include("heroku join --app #{app_name}-staging")
      expect(bin_setup).to include("git config heroku.remote staging")
      expect(File.stat(bin_setup_path)).to be_executable

      bin_deploy_path = "#{project_path}/bin/deploy"
      bin_deploy = IO.read(bin_deploy_path)

      expect(bin_deploy).to include("heroku run rake db:migrate")
      expect(File.stat(bin_deploy_path)).to be_executable

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
