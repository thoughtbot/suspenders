module BulldozerTestHelpers
  APP_NAME = "dummy_app"

  def remove_project_directory
    FileUtils.rm_rf(project_path)
  end

  def create_tmp_directory
    FileUtils.mkdir_p(tmp_path)
  end

  def run_bulldozer(arguments = nil)
    arguments = "--path=#{root_path} #{arguments}"
    run_in_tmp do
      add_fakes_to_path

      debug `#{bulldozer_bin} #{APP_NAME} #{arguments}`

      Dir.chdir(APP_NAME) do
        with_env("HOME", tmp_path) do
          debug `git add .`
          debug `git commit -m 'Initial commit'`
        end
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

      debug `#{system_rails_bin} new #{APP_NAME}`

      Dir.chdir(APP_NAME) do
        File.open("Gemfile", "a") do |file|
          file.puts %{gem "bulldozer", path: #{root_path.inspect}}
        end

        with_env("HOME", tmp_path) do
          debug `git add .`
          debug `git commit -m 'Initial commit'`
        end
      end
    end
  end

  def generate(generator)
    run_in_project do
      debug `bin/spring stop`
      debug `#{project_rails_bin} generate #{generator}`
    end
  end

  def destroy(generator)
    run_in_project do
      `bin/spring stop`
      `#{project_rails_bin} destroy #{generator}`
    end
  end

  def bulldozer_help_command
    run_in_tmp do
      debug `#{bulldozer_bin} -h`
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

  def bulldozer_bin
    File.join(root_path, 'bin', 'bulldozer')
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

  def run_in_tmp
    Dir.chdir(tmp_path) do
      Bundler.with_clean_env do
        yield
      end
    end
  end

  def run_in_project
    Dir.chdir(project_path) do
      Bundler.with_clean_env do
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
