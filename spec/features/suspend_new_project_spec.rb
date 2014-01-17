require 'spec_helper'

feature 'suspending a project' do
  scenario 'creates a new rails project' do
    expect(File.directory?(suspended_directory)).to be true
  end

  scenario 'creates a staging file which requires the production file' do
    staging_file = "#{suspended_directory}/config/environments/staging.rb"

    expect(IO.read(staging_file)).to eq template('staging.rb')
  end
end
