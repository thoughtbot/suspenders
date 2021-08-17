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
    FileUtils.cp_r app_fixture_path, app_path
    copy_file_ "spec_helper.rb", "spec/spec_helper.rb"
  end

  def destroy_app_dir
    FileUtils.rm_rf "#{tmp_path}/#{APP_NAME}"
  end

  # TODO: Consolidate with equivalent method from end-to-end helper
  def copy_file_(source_file, destination_file)
    source_path = template_path.join(source_file)
    destination_path = app_path.join(destination_file)

    destination_path.join("..").mkpath
    FileUtils.cp(source_path, destination_path)
  end

  def delete_file(file)
    app_path.join(file).delete
  end

  def touch_file(file)
    path = app_path.join(file)
    path.join("..").mkpath

    FileUtils.touch(app_path.join(file))
  end

  module_function

  def app_fixture_path
    fixtures_path.join(APP_NAME)
  end

  def app_path
    tmp_path.join(APP_NAME)
  end

  def template_path
    root_path.join("templates")
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
