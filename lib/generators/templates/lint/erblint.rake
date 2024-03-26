module ERBLint
  module RakeSupport
    # Allow command line flags set in STANDARDOPTS (like MiniTest's TESTOPTS)
    def self.argvify
      if ENV["ERBLINTOPTS"]
        ENV["ERBLINTOPTS"].split(/\s+/)
      else
        []
      end
    end

    # DELETE THIS FILE AFTER MERGE:
    #
    #   * https://github.com/Shopify/better-html/pull/95
    #
    def self.backport!
      BetterHtml::TestHelper::SafeErb::AllowedScriptType::VALID_JAVASCRIPT_TAG_TYPES.push("module")
    end
  end
end

desc "Lint templates with erb_lint"
task "erblint" do
  require "erb_lint/cli"
  require "erblint-github/linters"

  ERBLint::RakeSupport.backport!

  cli = ERBLint::CLI.new
  success = cli.run(ERBLint::RakeSupport.argvify + ["--lint-all", "--format=compact"])
  fail unless success
end

desc "Lint and automatically fix templates with erb_lint"
task "erblint:autocorrect" do
  require "erb_lint/cli"
  require "erblint-github/linters"

  ERBLint::RakeSupport.backport!

  cli = ERBLint::CLI.new
  success = cli.run(ERBLint::RakeSupport.argvify + ["--lint-all", "--autocorrect"])
  fail unless success
end

task "standard" => "erblint"
task "standard:fix" => "erblint:autocorrect"
