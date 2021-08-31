require "pathname"
require "json"

class FakeBundler
  TAPE = Pathname(__dir__).join("..", "..", "tmp", "bundler_info")

  def self.stub_unbundled_env!(spec, path:)
    spec.instance_eval do
      allow(Bundler).to receive(:unbundled_env).and_return(
        Bundler.unbundled_env.merge(
          "PATH" => path,
          "RAN_WITH_UNBUNDLED_ENV" => "true"
        )
      )
    end
  end

  def record!
    run_info = JSON.dump(
      given_args: ARGV.join(" "),
      gemfile_snapshot: File.read("Gemfile"),
      has_unbundled_env: ENV["RAN_WITH_UNBUNDLED_ENV"]
    )

    File.write(TAPE, run_info)
  end

  def ran?
    !run_info.empty?
  end

  def given_args
    run_info["given_args"]
  end

  def bundled_gemfile
    run_info["gemfile_snapshot"]
  end

  def unbundled_env?
    run_info["has_unbundled_env"]
  end

  private

  def run_info
    @run_info ||= JSON.parse(File.read(TAPE))
  rescue Errno::ENOENT, JSON::ParserError
    warn <<~MSG
      Could not find #{TAPE.basename} file!
      Fake bundler either did not run or the JSON from it is invalid.
    MSG
    {}
  end
end
