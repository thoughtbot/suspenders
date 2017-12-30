module SuspendersTestHelpers
  APP_NAME = "dummy_app"

  def remove_project_directory
    FileUtils.rm_rf(project_path)
  end

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def run_suspenders(arguments = nil)
    arguments = "--path=#{root_path} #{arguments}"
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        add_fakes_to_path
        with_revision_for_honeybadger do
          `
            #{suspenders_bin} #{APP_NAME} #{arguments}
          `
        end
        Dir.chdir(APP_NAME) do
          with_env("HOME", tmp_path) do
            `git add .`
            `git commit -m 'Initial commit'`
          end
        end
      end
    end
  end

  def suspenders_help_command
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        `
          #{suspenders_bin} -h
        `
      end
    end
  end

  def setup_app_dependencies
    if File.exist?(project_path)
      Dir.chdir(project_path) do
        Bundler.with_clean_env do
          `bundle check || bundle install`
        end
      end
    end
  end

  def drop_dummy_database
    if File.exist?(project_path)
      Dir.chdir(project_path) do
        Bundler.with_clean_env do
          `rails db:drop`
        end
      end
    end
  end

  def add_fakes_to_path
    ENV["PATH"] = "#{support_bin}:#{ENV['PATH']}"
  end

  def project_path
    @project_path ||= Pathname.new("#{tmp_path}/#{APP_NAME}")
  end

  def usage_file
    @usage_path ||= File.join(root_path, "USAGE")
  end

  private

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def suspenders_bin
    File.join(root_path, 'bin', 'suspenders')
  end

  def support_bin
    File.join(root_path, "spec", "fakes", "bin")
  end

  def root_path
    File.expand_path('../../../', __FILE__)
  end

  def with_env(name, new_value)
    had_key = ENV.has_key?(name)
    prior = ENV[name]
    ENV[name] = new_value.to_s

    yield

  ensure
    ENV.delete(name)

    if had_key
      ENV[name] = prior
    end
  end

  def with_revision_for_honeybadger
    with_env("HEROKU_SLUG_COMMIT", 1) do
      yield
    end
  end
end
