RSpec::Matchers.define :match_contents do |regexp|
  def file_contents(filename)
    TestPaths.app_path.join(filename).read
  end

  match do |filename|
    file_contents(filename) =~ regexp
  end

  failure_message do |filename|
    <<~MESSAGE
      #{filename} does not match the regex #{regexp}.
      The contents for #{filename} are:

      #{file_contents(filename)}
    MESSAGE
  end
end

RSpec::Matchers.define_negated_matcher :not_match_contents, :match_contents
