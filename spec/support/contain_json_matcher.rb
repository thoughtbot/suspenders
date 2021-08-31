# frozen_string_literal: true

require "json"

RSpec::Matchers.define :contain_json do
  match do
    @sub_json = expected
    @filename = actual

    filepath = TestPaths.app_path.join(@filename)
    @json = JSON.parse(filepath.read, symbolize_names: true)

    subhash?(@sub_json, @json)
  end

  failure_message do
    "in #{@filename}, expected to find\n#{@sub_json.inspect}\n" \
      "in\n#{@json.inspect}"
  end

  private

  def subhash?(inner, outer)
    if inner.is_a?(Hash) && outer.is_a?(Hash)
      inner.all? { |key, value| subhash?(value, outer[key]) }
    else
      inner == outer
    end
  end
end
