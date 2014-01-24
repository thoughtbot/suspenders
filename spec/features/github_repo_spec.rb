require 'spec_helper'

feature 'github repo' do
  before do
    @aruba_timeout_seconds = 560
  end

  after do
    FileUtils.rm_rf 'tmp/aruba/dummy'
  end

  scenario 'I suspend a project with a git repo specified' do
    project_name = 'dummy'
    repo_name = 'organization/project'

    run_simple "#{suspenders_bin} #{project_name} --github=#{repo_name}"

    expect(FakeGithub).to have_created_repo(repo_name)
  end
end

def suspenders_bin
  "#{root_path}/bin/suspenders"
end

def root_path
  Pathname.new(File.dirname(__FILE__)).parent.parent
end
