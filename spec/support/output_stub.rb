module OutputStub
  module_function

  def silence(output_device = File.new("/dev/null", "w"), &block)
    original_stdout = $stdout
    original_stderr = $stderr

    $stdout = $stderr = output_device

    yield block
  ensure
    $stdout = original_stdout
    $stderr = original_stderr
  end
end
