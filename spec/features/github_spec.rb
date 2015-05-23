require "spec_helper"

RSpec.describe "GitHub" do
  it "suspends a project with --github option" do
    repo_name = 'test'
    run_suspenders("--github=#{repo_name}")

    expect(FakeGithub).to have_created_repo(repo_name)
  end
end
