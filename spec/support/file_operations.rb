module FileOperations
  module_function

  def read_file(file)
    TestPaths.app_path.join(file).read
  end

  def touch_file(file)
    path = app_path.join(file)
    path.join("..").mkpath

    FileUtils.touch(TestPaths.app_path.join(file))
  end

  def rm_file(file)
    FileUtils.rm_rf(TestPaths.app_path.join(file))
  end

  def copy_file(source_file, destination_file)
    source_path = TestPaths.template_path.join(source_file)
    destination_path = TestPaths.app_path.join(destination_file)

    destination_path.join("..").mkpath
    FileUtils.cp(source_path, destination_path)
  end

  def create_tmp_directory
    FileUtils.mkdir_p(TestPaths.tmp_path)
  end

  def clear_tmp_directory
    FileUtils.rm_rf(Dir[TestPaths.tmp_path / "*"])
  end
end
