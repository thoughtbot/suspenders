require_relative "test_paths"
require_relative "file_operations"

module GeneratorTestHelpers
  include TestPaths
  include FileOperations

  def invoke!(klass, *args, **kwargs, &block)
    instance_eval(&block) if block
    call_generator!(new_invoke_generator(klass, *args, **kwargs))
  end

  def revoke!(klass, *args, **kwargs)
    call_generator!(new_revoke_generator(klass, *args, **kwargs))
  end

  def invoke_then_revoke!(klass, *args, **kwargs, &block)
    invoke! klass, *args, **kwargs, &block
    revoke! klass, *args, **kwargs
  end

  def call_generator!(generator)
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
    EnvPath.with_prepended_env_path(fake_bundler_bin_path) do |path|
      FakeBundler.stub_unbundled_env!(self, path: path)

      execute = lambda do
        clear_tmp_directory
        create_fake_app_dir
        Dir.chdir(app_path) { yield }
      end

      if @no_silence
        execute.call
      else
        OutputStub.silence { execute.call }
      end
    end
  end

  # This allows turning off output redirection per spec if you need to
  # debug or use a debugger such as pry
  def no_silence!
    @no_silence = true
  end

  def create_fake_app_dir
    FileUtils.cp_r fake_app_fixture_path, app_path
    copy_file "spec_helper.rb", "spec/spec_helper.rb"
  end

  def destroy_fake_app_dir
    FileUtils.rm_rf tmp_path.join(APP_NAME)
  end
end
