require 'spec_helper'

feature 'GitHub' do
  scenario 'Suspend a project with --github option' do
    repo_name = 'test'
    run_suspenders("--github=#{repo_name}")

    expect(FakeGithub).to have_created_repo(repo_name)
  end
end
