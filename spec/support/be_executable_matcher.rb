# frozen_string_literal: true

RSpec::Matchers.define :be_executable do
  match do |filename|
    TestPaths.app_path.join(filename).executable?
  end
end
