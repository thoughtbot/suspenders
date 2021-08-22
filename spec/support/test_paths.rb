# frozen_string_literal: true

module TestPaths
  extend self

  APP_NAME = "dummy_app"

  def app_path
    tmp_path.join(APP_NAME)
  end
  alias_method :project_path, :app_path

  def app_path!
    app_path = self.app_path
    raise "Expected #{app_path} to exist" unless app_path.exist?
    app_path
  end

  def template_path
    root_path.join("templates")
  end

  def fake_app_source_path
    root_path.join("spec", "support", "fixtures", APP_NAME)
  end

  def fakes_path
    root_path.join("spec", "support", "fakes")
  end

  def fake_bin_path
    fakes_path.join("bin")
  end

  def tmp_path
    @tmp_path ||= root_path.join("tmp")
  end

  def root_path
    @root_path ||= Pathname(__dir__).join("..", "..")
  end
end
