require_relative "test_paths"

module GeneratorTestHelpers
  include TestPaths

  def new_invoke_generator(klass, *given_args)
    new_generator(klass, *given_args, behavior: :invoke)
  end

  def invoke!(klass, *given_args, stub_bundler: false)
    generator = new_invoke_generator(klass, *given_args)
    BundlerStub.stub_bundle_install!(generator) if stub_bundler
    generator.invoke_all
    generator
  end

  def new_revoke_generator(klass, *given_args)
    new_generator(klass, *given_args, behavior: :revoke)
  end

  def revoke!(klass, *given_args, stub_bundler: false)
    generator = new_revoke_generator(klass, *given_args)
    BundlerStub.stub_bundle_install!(generator) if stub_bundler
    generator.invoke_all
    generator
  end

  def new_generator(klass, *given_args, **opts)
    args, = Thor::Options.split(given_args)
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
