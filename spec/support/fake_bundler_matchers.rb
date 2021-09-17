# FakeBundler records bundler information through a fake "bundler"
# binary. This RSpec matcher relies on that functionality.
RSpec::Matchers.define :have_bundled do |expected_bundler_args = ""|
  match do |file_str|
    raise 'Use expect("Gemfile")' if file_str != "Gemfile"

    fake_bundler = FakeBundler.new

    @ran_bundler = fake_bundler.ran?
    @with_unbundled_env = fake_bundler.unbundled_env?
    @actual_bundler_args = fake_bundler.given_args
    @unexpected_bundler_args = expected_bundler_args != fake_bundler.given_args
    @bundled_gemfile = fake_bundler.bundled_gemfile

    if !@ran_bundler || !@with_unbundled_env || @unexpected_bundler_args
      false
    elsif @gemfile_matching
      @bundled_gemfile.match?(@gemfile_matching)
    else
      true
    end
  end

  chain :matching do |regex|
    @gemfile_matching = regex
  end

  failure_message do
    if !@ran_bundler
      "The generator did not call bundler!"
    elsif !@with_unbundled_env
      <<~MSG
        Bundler was executed, but not with an unbundled env!
        Make sure to run your bundler command like this:

        Bundler.with_unbundled_env { run "bundle #{expected_bundler_args}" }
      MSG
    elsif @unexpected_bundler_args
      wrap_args = ->(args) { args.empty? ? "no args" : %("#{args}") }

      actual = wrap_args.call(@actual_bundler_args)
      expected = wrap_args.call(expected_bundler_args)

      <<~MSG
        Bundler was given unexpected arguments.
        Expected #{expected} but got #{actual}
      MSG
    elsif @gemfile_matching
      <<~MSG
        Gemfile does not match the given pattern!

        #{@bundled_gemfile}
      MSG
    end
  end
end

RSpec::Matchers.define_negated_matcher :not_have_bundled, :have_bundled
