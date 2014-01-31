require 'spec_helper'

feature 'suspending a project' do
  scenario 'creates a new rails project that is configured correctly' do
    set_command_line_arguments
    create_tmp_dir
    run_suspenders

    expect(File).to be_directory(suspended_directory)

    Bundler.with_clean_env do
      expect(`rake`).to include('0 failures')
    end
  end
end
