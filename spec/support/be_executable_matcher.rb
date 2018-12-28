# frozen_string_literal: true

RSpec::Matchers.define :be_executable do
  match do |filename|
    File.stat(File.join(project_path, filename)).executable?
  end
end
