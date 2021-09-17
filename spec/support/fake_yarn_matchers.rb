# FakeYarn records yarn information through a fake "bin/yarn"
# binary. This RSpec matcher relies on that functionality.
RSpec::Matchers.define :have_yarned do |expected_yarn_args = ""|
  match do |file_str|
    raise 'Use expect("package.json")' if file_str != "package.json"

    fake_yarn = FakeYarn.new

    @yarn_ran = fake_yarn.ran?
    @actual_yarn_args = fake_yarn.arguments

    @yarn_ran && expected_yarn_args == @actual_yarn_args
  end

  failure_message do
    if !@yarn_ran
      "The generator did not call yarn"
    else
      <<~MSG
        Yarn was executed, but the given arguments are incorrect.
        Expected "#{expected_yarn_args}" but got "#{@actual_yarn_args}"
      MSG
    end
  end
end
