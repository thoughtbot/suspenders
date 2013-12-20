require 'spec_helper'

feature 'github repo' do
  scenario 'I suspend a project with a git repo specified' do
    repo_name = 'test'
    set_command_line_arguments("--github=#{repo_name}")
    run_suspenders

    expect(FakeGithub).to have_created_repo(repo_name)
  end
end
