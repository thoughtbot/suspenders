RSpec.configure do |config|
  config.before(:suite) do
    set_command_line_arguments
    clean_suspended_directory
    create_tmp_dir
    run_suspenders
  end

  config.after(:suite) do
    clean_suspended_directory
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
  Suspenders::AppGenerator.start()
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
