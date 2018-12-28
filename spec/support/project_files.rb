module ProjectFiles
  def touch(filename)
    path = File.join(project_path, filename)
    dirname = File.dirname(path)
    FileUtils.mkdir_p(dirname)
    FileUtils.touch(path)
  end

  def rm(filename)
    path = File.join(project_path, filename)
    FileUtils.rm_rf(path)
  end
end
