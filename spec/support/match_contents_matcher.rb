RSpec::Matchers.define :match_contents do |regexp|
  match do |filename|
    contents = IO.read(File.join(project_path, filename))
    contents =~ regexp
  end
end

RSpec::Matchers.define_negated_matcher :not_match_contents, :match_contents
