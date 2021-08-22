require_relative "test_paths"
require_relative "file_operations"

module GeneratorTestHelpers
  include TestPaths
  include FileOperations

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

  def with_fake_app
    OutputStub.silence do
      clear_tmp_path
      create_fake_app_dir
      Dir.chdir(app_path) { yield }
    end
  end

  def create_fake_app_dir
    FileUtils.cp_r fake_app_source_path, app_path
    copy_file "spec_helper.rb", "spec/spec_helper.rb"
  end

  def destroy_fake_app_dir
    FileUtils.rm_rf tmp_path.join(APP_NAME)
  end
end
