RSpec::Matchers.define :match_original_file do
  match do |path|
    original_contents = GeneratorTestHelpers.app_template_path.join(path).read
    actual_contents = GeneratorTestHelpers.app_path.join(path).read

    original_contents == actual_contents
  end
end
