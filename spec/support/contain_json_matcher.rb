# frozen_string_literal: true

require "json"

RSpec::Matchers.define :contain_json do
  match do
    sub_json = expected
    filename = actual

    filepath = File.join(project_path, filename)
    json = JSON.parse(IO.read(filepath), symbolize_names: true)
    sub_json <= json
  end

  failure_message do
    sub_json = expected
    filename = actual

    filepath = File.join(project_path, filename)
    json = JSON.parse(IO.read(filepath), symbolize_names: true)

    "in #{filename}, expected to find\n#{sub_json.inspect}\nin\n#{json.inspect}"
  end
end
