require 'spec_helper'

feature 'New project' do
  scenario 'Suspend a project with default configurations' do
    run_suspenders

    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include('0 failures')
      end
    end
  end
end
