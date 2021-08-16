module GeneratorTestHelpers
  APP_NAME = "dummy_app"

  def new_invoke_generator(klass, *given_args)
    new_generator(klass, *given_args, behavior: :invoke)
  end

  def new_revoke_generator(klass, *given_args)
    new_generator(klass, *given_args, behavior: :revoke)
  end

  def new_generator(klass, *given_args, **opts)
    args, = Thor::Options.split(given_args)
    klass.new(args, [], destination_root: app_path, **opts)
  end

  def with_app_dir
    OutputStub.silence do
      create_app_dir
      yield
    ensure
      destroy_app_dir
    end
  end

  def create_app_dir
    FileUtils.cp_r app_template_path, app_path
  end

  def destroy_app_dir
    FileUtils.rm_rf "#{tmp_path}/#{APP_NAME}"
  end

  module_function

  def app_template_path
    fixtures_path.join(APP_NAME)
  end

  def app_path
    tmp_path.join(APP_NAME)
  end

  def app_path!
    app_path = self.app_path

    unless app_path.exist?
      raise "Expected #{app_path} to exist"
    end

    app_path
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
