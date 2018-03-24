require "spec_helper"

RSpec.describe "Suspend a new project with --api flag" do
  before(:all) do
    drop_dummy_database
    remove_project_directory
  end

  it "ensures project specs pass" do
    run_suspenders("--api")

    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include("0 failures")
      end
    end
  end
end
