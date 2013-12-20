module SuspendersTestHelpers
  APP_NAME = 'dummy'

  def drop_dummy_database
    Dir.chdir(suspended_directory) do
      Bundler.with_clean_env do
        `bundle exec rake db:drop`
      end
    end
  end

  def clean_suspended_directory
    Dir.chdir(root_path)
    FileUtils.rm_rf(suspended_directory)
  end

  def create_tmp_dir
    FileUtils.mkdir_p("#{root_path}/tmp")
  end

  def set_command_line_arguments(arguments = nil)
    arguments = "#{suspended_directory} #{arguments}"
    ARGV.replace(arguments.split(' '))
  end

  def run_suspenders
    Suspenders::AppGenerator.start
  end

  def suspended_directory
    @suspended_directory ||= "#{root_path}/tmp/#{APP_NAME}"
  end

  def template(file)
    IO.read("#{root_path}/templates/#{file}")
  end

  def root_path
    File.expand_path('../../', __FILE__)
  end
end
