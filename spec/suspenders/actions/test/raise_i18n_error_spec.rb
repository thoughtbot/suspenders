require "tmpdir"
require "spec_helper"

RSpec.describe Suspenders::Actions::Test::RaiseI18nError do
  describe "#apply" do
    it "enables the raising of errors for missing translations" do
      within_temp_app do |app_dir|
        action = Suspenders::Actions::Test::RaiseI18nError.new([app_dir])
        write_file action.file_path, <<~RUBY
          # Raises error for missing translations.
          # config.i18n.raise_on_missing_translations = true
        RUBY

        action.apply

        expect(File.read(action.file_path))
          .to match(/^\s*config\.i18n\.raise_on_missing_translations = true/)
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
