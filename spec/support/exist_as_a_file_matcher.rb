# frozen_string_literal: true

RSpec::Matchers.define :exist_as_a_file do
  match do |filename|
    File.exist?(File.join(project_path, filename))
  end
end
