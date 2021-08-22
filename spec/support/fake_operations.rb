module FakeOperations
  extend self

  def add_fakes_to_path
    ENV["PATH"] = "#{TestPaths.fake_bin_path}:#{ENV["PATH"]}"
  end
end
