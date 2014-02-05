require 'spec_helper'

feature 'Suspend a new project with default configuration' do
  scenario 'specs pass' do
    run_suspenders

    Dir.chdir(project_path) do
      Bundler.with_clean_env do
        expect(`rake`).to include('0 failures')
      end
    end
  end

  scenario 'staging config is inherited from production' do
    run_suspenders

    staging_file = "#{project_path}/config/environments/staging.rb"

    expect(IO.read(staging_file)).to eq template('staging.rb')
  end
end
