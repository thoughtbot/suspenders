require "spec_helper"

RSpec.describe "CircleCI" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
    run_suspenders
    setup_app_dependencies
  end

  it "creates CircleCI config file" do
    expect(File).to exist("#{project_path}/.circleci/config.yml")
  end

  it "uses the app name in the config file" do
    circleci_config = IO.read("#{project_path}/.circleci/config.yml")

    expect(circleci_config).to match(/working_directory: ~\/#{app_name}/)
  end

  def app_name
    SuspendersTestHelpers::APP_NAME
  end
end
