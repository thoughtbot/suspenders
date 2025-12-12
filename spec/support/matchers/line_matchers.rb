RSpec::Matchers.define :have_commented do |expected_line|
  match do |file_path|
    content = File.read file_path
    uncommented_pattern = /^\s*#{Regexp.escape expected_line}/
    commented_pattern = /^\s*#\s#{Regexp.escape expected_line}$/

    content.match?(commented_pattern) && !content.match?(uncommented_pattern)
  end

  failure_message do |file_path|
    content = File.read file_path
    commented_pattern = /^\s*#\s#{Regexp.escape expected_line}$/

    unless content.match? commented_pattern
      "expected #{file_path} to have commented line: #{expected_line}"
    end
  end

  failure_message_when_negated do |file_path|
    "expected #{file_path} not to have commented line: #{expected_line}"
  end
end
