require "spec_helper"

RSpec.describe "GitHub", type: :feature, autoclean: false do
  before do
    drop_dummy_database
    clear_tmp_directory
  end

  it "suspends a project with --github option" do
    repo_name = "test"
    run_suspenders("--github=#{repo_name}")
    setup_app_dependencies

    expect(FakeGithub).to have_created_repo(repo_name)
  end
end
