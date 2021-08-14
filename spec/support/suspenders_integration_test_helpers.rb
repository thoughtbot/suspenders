module SuspendersIntegrationTestHelpers
  APP_NAME = "dummy_app"

  def self.included(spec)
    spec.after { destroy_app_dir! }
  end

  def generate(generator_klass, *args)
    create_app_dir!
    within_app_dir do
      generator_klass.start(args, behavior: :invoke)
    end
  end

  def destroy(generator_klass)
    within_app_dir do
      generator_klass.start([], behavior: :revoke)
    end
  end

  def create_app_dir!
    FileUtils.cp_r app_template_path, app_path
  end

  def destroy_app_dir!
    FileUtils.rm_rf app_path
  end

  def destroy_app_dir!
    FileUtils.rm_rf "#{tmp_path}/#{APP_NAME}"
  end

  def within_app_dir
    run_in_tmp do
      Dir.chdir(APP_NAME) { yield }
    end
  end

  def run_in_tmp
    Dir.chdir(tmp_path) do
      Bundler.with_unbundled_env do
        yield
      end
    end
  end

  def app_template_path
    fixtures_path.join(APP_NAME)
  end

  def app_path
    tmp_path.join(APP_NAME)
  end

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def root_path
    Pathname(__dir__).join("../..")
  end

  def fixtures_path
    root_path.join("spec/fixtures")
  end
end
