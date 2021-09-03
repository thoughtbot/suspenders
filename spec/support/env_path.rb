module EnvPath
  module_function

  def prepend_env_path!(path)
    ENV["PATH"] = prepend_env_path(path)
  end

  def prepend_env_path(path)
    "#{path}:#{ENV["PATH"]}"
  end

  def with_prepended_env_path(*paths)
    old_path = ENV["PATH"]
    paths.each { |path| ENV["PATH"] = prepend_env_path(path) }
    yield ENV["PATH"]
  ensure
    ENV["PATH"] = old_path
  end
end
