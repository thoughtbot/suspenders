require "English"
require_relative "env_path"
require_relative "file_operations"
require_relative "test_paths"

module FeatureTestHelpers
  include TestPaths
  include FileOperations

  def remove_project_directory
    FileUtils.rm_rf(project_path)
  end

  def run_suspenders(arguments = nil)
    arguments = "--path=#{root_path} #{arguments}"
    run_in_tmp do
      EnvPath.prepend_env_path!(fake_bin_path)
      command = "#{suspenders_bin} _#{rails_version}_ #{APP_NAME} #{arguments}"

      with_revision_for_honeybadger do
        result = `#{command}`
        debug result
      end

      yield command if block_given?

      Dir.chdir(APP_NAME) do
        commit_all
      end
    end
  end

  def run_suspenders!(*args)
    run_suspenders(*args) do |command|
      if $CHILD_STATUS.exitstatus.nonzero?
        raise <<~MESSAGE
          Suspenders failed. To debug, generate an app with:

          #{command}

          Or run rspec with SHOW_DEBUG=true to display the full output.
        MESSAGE
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
      EnvPath.prepend_env_path!(fake_bin_path)

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

  def usage_file
    @usage_path ||= File.join(root_path, "USAGE")
  end

  private

  def suspenders_bin
    File.join(root_path, "bin", "suspenders")
  end

  def system_rails_bin
    "rails"
  end

  def project_rails_bin
    "bin/rails"
  end

  def rails_template_path
    root_path.join("spec", "support", "rails_template.rb")
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
    if ENV["SHOW_DEBUG"]
      warn output
    end

    output
  end
end
