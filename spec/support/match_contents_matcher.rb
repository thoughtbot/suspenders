RSpec::Matchers.define :match_contents do |regexp|
  match do |filename|
    @filename = filename
    @contents = TestPaths.app_path.join(filename).read
    @contents =~ regexp
  end

  failure_message do
    <<~MESSAGE
      #{@filename} does not match the regex #{regexp}.
      #{@filename} contents are:

      #{@contents}
    MESSAGE
  end
end

RSpec::Matchers.define_negated_matcher :not_match_contents, :match_contents
