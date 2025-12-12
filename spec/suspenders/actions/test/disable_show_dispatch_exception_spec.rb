require "tmpdir"
require "spec_helper"

RSpec.describe Suspenders::Actions::Test::DisableShowDispatchException do
  describe "#apply" do
    it "disables the action dispatch show exceptions configuration" do
      within_temp_app do |app_dir|
        action = Suspenders::Actions::Test::DisableShowDispatchException.new
        action.destination_root = app_dir
        file_path = File.join(
          app_dir,
          Suspenders::Actions::Test::DisableShowDispatchException::TARGET_FILE
        )
        write_file file_path, <<~RUBY
          # Render exception templates for rescuable exceptions and raise for other exceptions.
          config.action_dispatch.show_exceptions = :rescuable
        RUBY

        action.apply

        expect(File.read(file_path)).to match(
          /^\s*#\sconfig\.action_dispatch\.show_exceptions\s=\s:rescuable$/
        )
        expect(File.read(file_path)).not_to match(
          /^\s*config\.action_dispatch\.show_exceptions\s=\s:rescuable$/
        )
      end
    end
  end

  def within_temp_app
    Dir.mktmpdir do |dir|
      yield dir
    end
  end

  def write_file(file_path, content)
    FileUtils.mkdir_p File.dirname(file_path)
    File.write file_path, content
  end
end
