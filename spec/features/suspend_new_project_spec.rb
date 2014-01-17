require 'spec_helper'

feature 'suspending a project' do
  before(:all) do
    set_command_line_arguments
    clean_suspended_directory
    create_tmp_dir
    run_suspenders
  end

  after(:all) do
    drop_dummy_database
    clean_suspended_directory
  end

  scenario 'creates a new rails project' do
    expect(File.directory?(suspended_directory)).to be true
  end

  it 'creates a staging file which requires the production file' do
    staging_file = "#{suspended_directory}/config/environments/staging.rb"

    expect(IO.read(staging_file)).to eq template('staging.rb')
  end
end

def drop_dummy_database
  Dir.chdir(suspended_directory) do
    Bundler.with_clean_env do
      %x[bundle exec rake db:drop]
    end
  end
end

def clean_suspended_directory
  FileUtils.rm_rf(suspended_directory)
end

def create_tmp_dir
  FileUtils.mkdir_p("#{root_path}/tmp")
end

def set_command_line_arguments
  ARGV.replace([suspended_directory])
end

def run_suspenders
  Suspenders::AppGenerator.start
end

def suspended_directory
  @suspended_directory ||= "#{root_path}/tmp/dummy"
end

def template(file)
  IO.read("#{root_path}/templates/#{file}")
end

def root_path
  Pathname.new(File.dirname(__FILE__)).parent.parent
end
