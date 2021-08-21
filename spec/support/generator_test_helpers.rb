require_relative "test_paths"

module GeneratorTestHelpers
  include TestPaths

  def invoke!(klass, *args, **kwargs)
    call_generator!(:new_invoke_generator, klass, *args, **kwargs)
  end

  def revoke!(klass, *args, **kwargs)
    call_generator!(:new_revoke_generator, klass, *args, **kwargs)
  end

  def call_generator!(method, klass, *args, stub_bundler: false)
    generator = __send__(method, klass, *args)
    BundlerStub.stub_bundle_install!(generator) if stub_bundler
    generator.invoke_all
    generator
  end

  def new_invoke_generator(klass, *args)
    new_generator(klass, *args, behavior: :invoke)
  end

  def new_revoke_generator(klass, *args)
    new_generator(klass, *args, behavior: :revoke)
  end

  def new_generator(klass, *args, **opts)
    klass.new(args, [], destination_root: app_path, **opts)
  end

  def with_app_dir
    OutputStub.silence do
      create_app_dir
      Dir.chdir(app_path) { yield }
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
end
