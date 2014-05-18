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

    staging_file = IO.read("#{project_path}/config/environments/staging.rb")
    config_stub = "Rails.application.configure do"
    expect(staging_file).to match(/^require_relative 'production'/)
    expect(staging_file).to match(/#{config_stub}/), staging_file
  end

  scenario '.ruby-version does not include patchlevel' do
    run_suspenders

    ruby_version_file = IO.read("#{project_path}/.ruby-version")
    expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
  end
end
