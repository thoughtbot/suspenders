require "spec_helper"

RSpec.describe "Suspend a new project with --api flag", type: :feature do
  before(:all) do
    drop_dummy_database
    clear_tmp_directory
  end

  it "ensures project specs pass" do
    run_suspenders("--api")

    Dir.chdir(project_path) do
      Bundler.with_unbundled_env do
        expect(`rake`).to include("0 failures")
      end
    end
  end
end
