# frozen_string_literal: true

RSpec::Matchers.define :have_bundled do |actual_bundler_args = ""|
  match do |file_str|
    raise 'Use expect("Gemfile")' if file_str != "Gemfile"

    bundler_args_file = project_path.join(".bundler_arguments")
    bundled_gemfile_file = project_path.join("Gemfile.bundled")
    rename_file = ->(file) { FileUtils.mv(file, "#{file.expand_path}.past") }

    @called_bundler = bundler_args_file.exist?
    @given_bundler_args = @called_bundler && bundler_args_file.read.chomp
    @unexpected_bundler_args = actual_bundler_args != @given_bundler_args
    @bundled_gemfile = @called_bundler && bundled_gemfile_file.read

    if @called_bundler
      rename_file.call(bundler_args_file)
      rename_file.call(bundled_gemfile_file)
    end

    if !@called_bundler
      false
    elsif @unexpected_bundler_args
      false
    elsif @gemfile_matching
      @bundled_gemfile.match?(@gemfile_matching)
    else
      true
    end
  end

  chain :with_gemfile_matching do |regex|
    @gemfile_matching = regex
  end

  failure_message do
    if !@called_bundler
      "The generator did not call bundler!"
    elsif @unexpected_bundler_args
      wrap_args = ->(args) { args.empty? ? "no args" : %("#{args}") }

      given = wrap_args.call(@given_bundler_args)
      actual = wrap_args.call(actual_bundler_args)

      <<~MSG
        Bundler was given unexpected arguments.
        Expected #{given} but got #{actual}
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
