module SuspendersTestHelpers
  APP_NAME = 'dummy'

  def remove_project_directory
    FileUtils.rm_rf(project_path)
  end

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def run_suspenders(arguments = nil)
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        ENV['TESTING'] = '1'

        %x(#{suspenders_bin} #{APP_NAME} #{arguments})
        copy_sample_factory
      end
    end
  end

  def drop_dummy_database
    if File.exists?(project_path)
      Dir.chdir(project_path) do
        Bundler.with_clean_env do
          `rake db:drop`
        end
      end
    end
  end

  def project_path
    @project_path ||= Pathname.new("#{tmp_path}/#{APP_NAME}")
  end

  private

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def suspenders_bin
    File.join(root_path, 'bin', 'suspenders')
  end

  def root_path
    File.expand_path('../../../', __FILE__)
  end

  def copy_sample_factory
    FileUtils.mkdir_p(project_factories_path)
    FileUtils.cp(sample_factory_path, project_factories_path)
  end

  def project_factories_path
    File.join(project_path, 'spec', 'factories')
  end

  def sample_factory_path
    File.join(root_path, 'spec', 'fixtures', 'sample_factory.rb')
  end
end
