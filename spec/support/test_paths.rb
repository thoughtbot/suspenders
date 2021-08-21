# frozen_string_literal: true

module TestPaths
  APP_NAME = "dummy_app"

  extend self

  def app_path
    tmp_path.join(APP_NAME)
  end
  alias_method :project_path, :app_path

  def app_path!
    app_path = self.app_path

    unless app_path.exist?
      raise "Expected #{app_path} to exist"
    end

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

  def tmp_path
    @tmp_path ||= root_path.join("tmp")
  end

  def root_path
    @root_path ||= Pathname(__dir__).join("..", "..")
  end
end
