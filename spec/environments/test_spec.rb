require "tmpdir"
require "spec_helper"

RSpec.describe "Test environment" do
  it "enables the raising of errors for missing translations" do
    dummy_path = File.expand_path("../dummy", __dir__)
    # binding.irb
    backup_file_file_path = File.join(dummy_path, "config/environments/test.rb")
    backup_file = File.read(backup_file_file_path)
    template_path = File.expand_path("../../lib/templates/web.rb", __dir__)
    # binding.irb
    Dir.chdir dummy_path do
      ENV["BUNDLE_GEMFILE"] = File.join(dummy_path, "Gemfile")
      system("bin/rails app:template LOCATION=#{template_path}")
    end
    configuration = File.read(
      File.join(
        dummy_path,
        "config/environments/test.rb"
      )
    )

    expect(configuration)
      .to match(/^\s*config\.i18n\.raise_on_missing_translations\s=\strue$/)
    expect(configuration)
      .not_to match(/^\s*#\sconfig\.i18n\.raise_on_missing_translations/)

    File.write(backup_file_file_path, backup_file)
  end

  it "disables action dispatch show exceptions" do
    with_temp_directory do |tmp_dir|
      generate tmp_dir, "test_app"
      configuration = File.read(
        File.join(
          tmp_dir,
          "test_app",
          "config/environments/test.rb"
        )
      )

      expect(configuration).to match(/^\s*#\sconfig\.action_dispatch\.show_exceptions\s=\s:rescuable$/)
      expect(configuration).not_to match(/^\s*config\.action_dispatch\.show_exceptions\s=\s:rescuable$/)
    end
  end

  def with_temp_directory
    yield Dir.mktmpdir
  end

  def generate(directory, app_name)
    Dir.chdir directory do
      Suspenders::CLI.run app_name
    end
  end
end
