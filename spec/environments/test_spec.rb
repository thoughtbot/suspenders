require "tmpdir"
require "spec_helper"

RSpec.describe "Test environment" do
  it "enables the raising of errors for missing translations" do
    backup_file "config/environments/test.rb" do
      apply_template

      configuration = file_content "config/environments/test.rb"

      expect(configuration)
        .to match(/^\s*config\.i18n\.raise_on_missing_translations\s=\strue$/)
      expect(configuration)
        .not_to match(/^\s*#\sconfig\.i18n\.raise_on_missing_translations$/)
    end
  end

  it "disables action dispatch show exceptions" do
    backup_file "config/environments/test.rb" do
      apply_template

      configuration = file_content "config/environments/test.rb"

      expect(configuration).to match(
        /^\s*#\sconfig\.action_dispatch\.show_exceptions\s=\s:rescuable$/
      )
      expect(configuration).not_to match(
        /^\s*config\.action_dispatch\.show_exceptions\s=\s:rescuable$/
      )
    end
  end

  def dummy_path
    File.expand_path "../dummy", __dir__
  end

  def file_content(relative_path)
    File.read File.join(dummy_path, relative_path)
  end

  def apply_template
    template_path = File.expand_path("../../lib/templates/web.rb", __dir__)

    Dir.chdir dummy_path do
      ENV["BUNDLE_GEMFILE"] = File.join(dummy_path, "Gemfile")
      system("bin/rails app:template LOCATION=#{template_path}")
    end
  end

  def backup_file(relative_path)
    full_path = File.join dummy_path, relative_path
    backed_up_file = File.read full_path

    yield

    File.write full_path, backed_up_file
  end
end
