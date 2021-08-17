# frozen_string_literal: true

module BundlerStub
  module BundlerStub
    attr_reader :__gemfile_snapshot__

    def bundle_install
      app_path = GeneratorTestHelpers.app_path!
      @__gemfile_snapshot__ = IO.read(app_path.join("Gemfile"))
    end
  end

  def stub_bundle_install!(generator)
    generator.singleton_class.prepend(BundlerStub)
  end

  RSpec::Matchers.define :have_bundled do |_|
    match do |generator|
      unless generator.singleton_class.included_modules.first == BundlerStub
        "Please stub the generator with stub_bundle_install! " \
          "before using this matcher"
      end

      snapshot = generator.__gemfile_snapshot__
      @called_bundler = !snapshot.nil?

      if !@called_bundler
        false
      elsif @gemfile_matching
        snapshot&.match?(@gemfile_matching)
      elsif @gemfile_not_matching
        !snapshot&.match?(@gemfile_not_matching)
      else
        true
      end
    end

    chain :with_gemfile_matching do |regex|
      @gemfile_matching = regex
    end

    chain :with_gemfile_not_matching do |regex|
      @gemfile_not_matching = regex
    end

    failure_message do
      if !@called_bundler
        "The generator did not call bundler!"
      elsif @gemfile_matching
        "Gemfile does not match the given pattern!"
      else
        "Gemfile matches the given pattern, but it should not!"
      end
    end
  end
end
