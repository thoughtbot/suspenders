require 'spec_helper'

feature 'Suspend a new project with default configuration' do
  scenario 'everything is good' do
    run_suspenders

    Dir.chdir(project_path) do
      Bundler.with_clean_env { expect(`rake`).to include('0 failures') }
      expect(File).to exist('spec/support/features.rb')
    end
  end

  scenario 'staging config is inherited from production' do
    run_suspenders

    staging_file = IO.read("#{project_path}/config/environments/staging.rb")
    config_stub = "Dummy::Application.configure do"
    expect(staging_file).to match(/^require_relative 'production'/)
    expect(staging_file).to match(/#{config_stub}/), staging_file
  end

  if RUBY_PATCHLEVEL == 0 && RUBY_VERSION >= '2.1.0'
    scenario '.ruby-version does not include patchlevel for Ruby 2.1.0+' do
      run_suspenders

      ruby_version_file = IO.read("#{project_path}/.ruby-version")
      expect(ruby_version_file).to eq "#{RUBY_VERSION}\n"
    end
  else
    scenario '.ruby-version includes patchlevel for all pre-Ruby 2.1.0 versions' do
      run_suspenders

      ruby_version_file = IO.read("#{project_path}/.ruby-version")
      expect(ruby_version_file).to eq "#{RUBY_VERSION}-p#{RUBY_PATCHLEVEL}\n"
    end
  end
end
