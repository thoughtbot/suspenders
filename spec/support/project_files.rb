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

  def copy_file(from_in_templates, to_in_project)
    destination = File.join(project_path, to_in_project)
    destination_dirname = File.dirname(destination)

    FileUtils.mkdir_p(destination_dirname)

    FileUtils.cp(
      File.join(root_path, "templates", from_in_templates),
      destination
    )
  end
end
