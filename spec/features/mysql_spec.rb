require "spec_helper"

RSpec.describe "MySQL" do
  before do
    remove_project_directory
  end

  it "suspends a project with -d mysql option" do
    run_suspenders("-d mysql")
    setup_app_dependencies

    expect(FakeMysql).to have_gem_included(project_path, "mysql2")
    expect(FakeMysql).to have_mysql_adapter(project_path)
  end
end
