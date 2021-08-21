module FileOperations
  def touch_file(file)
    path = app_path.join(file)
    path.join("..").mkpath

    FileUtils.touch(app_path.join(file))
  end

  def rm_file(file)
    FileUtils.rm_rf(app_path.join(file))
  end

  def copy_file(source_file, destination_file)
    source_path = template_path.join(source_file)
    destination_path = app_path.join(destination_file)

    destination_path.join("..").mkpath
    FileUtils.cp(source_path, destination_path)
  end
end
