require "pathname"

class FakeYarn
  TAPE = Pathname(__dir__).join("..", "..", "tmp", "yarn_info")

  def record!
    File.write(TAPE, ARGV.join(" "))
  end

  def ran?
    !arguments.empty?
  end

  def arguments
    @arguments ||= File.read(TAPE)
  rescue Errno::ENOENT
    warn <<~MSG
      Could not find #{TAPE.basename} file!
      Fake yarn did not run.
    MSG

    ""
  end
end
