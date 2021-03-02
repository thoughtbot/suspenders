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
    run_in_tmp do
      add_fakes_to_path

      with_revision_for_honeybadger do
        debug `#{suspenders_bin} _#{rails_version}_ #{APP_NAME} #{arguments}`
      end

      Dir.chdir(APP_NAME) do
        commit_all
      end
    end
  end

  def with_app
    drop_dummy_database
    remove_project_directory
    rails_new
    setup_app_dependencies

    yield
  end

  def rails_new
    run_in_tmp do
      add_fakes_to_path

      with_revision_for_honeybadger do
        debug `#{system_rails_bin} _#{rails_version}_ new #{APP_NAME} --skip-spring -d postgresql -m #{rails_template_path}`
      end

      Dir.chdir(APP_NAME) do
        commit_all
      end
    end
  end

  def generate(generator)
    run_in_project do
      with_revision_for_honeybadger do
        debug `#{project_rails_bin} generate #{generator}`
      end
    end
  end

  def destroy(generator)
    run_in_project do
      with_revision_for_honeybadger do
        debug `#{project_rails_bin} destroy #{generator}`
      end
    end
  end

  def suspenders_help_command
    run_in_tmp do
      debug `#{suspenders_bin} -h`
    end
  end

  def setup_app_dependencies
    run_in_project do
      debug `bundle check || bundle install`
    end
  rescue Errno::ENOENT
    # The project_path might not exist, in which case we can skip this.
  end

  def drop_dummy_database
    run_in_project do
      debug `#{project_rails_bin} db:drop 2>&1`
    end
  rescue Errno::ENOENT
    # The project_path might not exist, in which case we can skip this.
  end

  def add_fakes_to_path
    ENV["PATH"] = "#{support_bin}:#{ENV["PATH"]}"
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
    File.join(root_path, "bin", "suspenders")
  end

  def system_rails_bin
    "rails"
  end

  def project_rails_bin
    "bin/rails"
  end

  def support_bin
    File.join(root_path, "spec", "fakes", "bin")
  end

  def root_path
    File.expand_path("../../../", __FILE__)
  end

  def rails_template_path
    File.join(root_path, "spec", "support", "rails_template.rb")
  end

  def rails_version
    Rails::VERSION::STRING
  end

  def commit_all
    with_env("HOME", tmp_path) do
      debug `git config user.email suspenders@example.com`
      debug `git config user.name "Suspenders Boy"`
      debug `git add .`
      debug `git commit -m 'Initial commit'`
    end
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

  def run_in_tmp
    Dir.chdir(tmp_path) do
      Bundler.with_unbundled_env do
        yield
      end
    end
  end

  def run_in_project
    Dir.chdir(project_path) do
      Bundler.with_unbundled_env do
        yield
      end
    end
  end

  def debug(output)
    if ENV["DEBUG"]
      warn output
    end

    output
  end
end
