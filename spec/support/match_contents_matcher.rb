RSpec::Matchers.define :match_contents do |regexp|
  match do |filename|
    contents = TestPaths.app_path.join(filename).read
    contents =~ regexp
  end
end

RSpec::Matchers.define_negated_matcher :not_match_contents, :match_contents
