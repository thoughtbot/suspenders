RSpec::Matchers.define :match_original_file do
  match do |path|
    @path = path
    @original_contents = TestPaths.fake_app_fixture_path.join(path).read
    @actual_contents = TestPaths.app_path.join(path).read

    @original_contents == @actual_contents
  end

  failure_message do
    <<~MESSAGE
      #{@path} does not match original file. The diff is:
      #{differ.diff_as_string(@actual_contents, @original_contents)}
    MESSAGE
  end

  def differ
    RSpec::Support::Differ.new(
      object_preparer: lambda do |object|
        RSpec::Matchers::Composable.surface_descriptions_in(object)
      end,
      color: RSpec::Matchers.configuration.color?
    )
  end
end

RSpec::Matchers.define :have_no_syntax_error do
  # rubocop:disable Lint/RescueException
  match do |path|
    load GeneratorTestHelpers.app_path.join(path)
  rescue SyntaxError
    false
  rescue Exception
    true
  end
  # rubocop:enable Lint/RescueException

  failure_message do
    "The file #{@file} has syntax errors"
  end
end
