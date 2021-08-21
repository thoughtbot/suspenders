# frozen_string_literal: true

module TestPaths
  APP_NAME = "dummy_app"

  extend self

  def app_fixture_path
    fixtures_path.join(APP_NAME)
  end

  def app_path
    tmp_path.join(APP_NAME)
  end
  alias_method :project_path, :app_path

  def fakes_path
    root_path.join("spec/fakes")
  end

  def template_path
    root_path.join("templates")
  end

  def app_path!
    app_path = self.app_path

    unless app_path.exist?
      raise "Expected #{app_path} to exist"
    end

    app_path
  end

  def tmp_path
    @tmp_path ||= Pathname.new("#{root_path}/tmp")
  end

  def root_path
    Pathname(__dir__).join("../..")
  end

  def fixtures_path
    root_path.join("spec/fixtures")
  end
end
