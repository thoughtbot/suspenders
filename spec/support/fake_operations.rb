module FakeOperations
  extend self

  def add_fakes_to_path
    ENV["PATH"] = "#{TestPaths.fake_bin_path}:#{ENV["PATH"]}"
  end

  def with_temp_path(path)
    old_path = ENV["PATH"]
    ENV["PATH"] = "#{path}:#{ENV["PATH"]}"
    yield ENV["PATH"]
  ensure
    ENV["PATH"] = old_path
  end
end
