# frozen_string_literal: true

RSpec::Matchers.define :exist_as_a_file do
  match do |filename|
    TestPaths.app_path.join(filename).exist?
  end
end
